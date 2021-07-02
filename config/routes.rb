# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :registrations, controllers: {
    sessions: "users/sessions",
    confirmations: "users/confirmations",
  }
  devise_scope :user do
    get "/users/confirm-sign-in", to: "users/sessions#redirect_from_magic_link"
    post "/users/sign-in-with-token", to: "users/sessions#sign_in_with_token"
    get "/users/signed-out", to: "users/sessions#signed_out"
    get "/users/link-invalid", to: "users/sessions#link_invalid"
  end

  get "check" => "application#check"
  get "healthcheck" => "healthcheck#check"

  resource :cookies, only: %i[show update]
  resource :privacy_policy, only: %i[show], path: "privacy-policy"
  resource :dashboard, controller: :dashboard, only: :show
  resource :preferred_name, path: "preferred-name", controller: :preferred_name, only: %i[edit update]

  get "/403", to: "errors#forbidden", via: :all
  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all

  unless Rails.env.production?
    get "/govspeak_test", to: "govspeak_test#show"
    post "/govspeak_test", to: "govspeak_test#preview"
  end

  # index needs a path
  resources :core_induction_programmes, module: :core_induction_programmes, path: "providers", only: :index, as: "cip"

  providers = "ambition|ucl|edt|teach-first"
  id_regex = Rails.env.test? ? Regexp.new("#{providers}|test-.*") : Regexp.new(providers)

  resources :core_induction_programmes, module: :core_induction_programmes, path: "/", constraints: { id: id_regex }, only: :show, as: "cip" do
    get "create-module", to: "modules#new"
    post "create-module", to: "modules#create"

    get "create-lesson", to: "lessons#new"
    post "create-lesson", to: "lessons#create"

    resources :years, only: %i[show new create edit update], path: "/", constraints: { id: /year-1|year-2/ } do
      resources :modules, only: %i[show edit update], path: "/", constraints: { id: /(autumn|spring|summer)-\d+/ } do
        resources :lessons, only: %i[show edit update], path: "/", constraints: { id: /topic-\d+/ } do
          resources :lesson_parts, only: %i[show edit update destroy], path: "/", constraints: { id: /part-\d+/ } do
            get "split", to: "lesson_parts#show_split", as: "split"
            post "split", to: "lesson_parts#split"
            get "delete", as: "show_delete", to: "lesson_parts#show_delete"
            put "update-progress", to: "lesson_parts#update_progress", as: :update_progress
          end

          resources :mentor_materials, only: %i[show edit update], path: "mentoring", constraints: { id: /\d+/ } do
            resources :mentor_material_parts, only: %i[show edit update destroy], path: "/", constraints: { id: /part-\d+/ } do
              get "split", to: "mentor_material_parts#show_split", as: "split"
              post "split", to: "mentor_material_parts#split"
              get "delete", as: "show_delete", to: "mentor_material_parts#show_delete"
            end
          end
        end
      end
    end
  end

  resources :mentor_materials, module: :core_induction_programmes, only: %i[index new create], path: "mentor-materials"

  get "download-export", to: "core_induction_programmes/core_induction_programmes#download_export", as: :download_export

  root to: "start#index"

  get "training-and-support" => "training_and_support#show"
end
