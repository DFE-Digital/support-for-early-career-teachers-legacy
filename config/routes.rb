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

  resources :core_induction_programmes, path: "core-induction-programmes", only: %i[show index], as: "cip" do
    get "create-module", to: "core_induction_programmes/modules#new"
    post "create-module", to: "core_induction_programmes/modules#create"

    get "create-lesson", to: "core_induction_programmes/lessons#new"
    post "create-lesson", to: "core_induction_programmes/lessons#create"
  end

  get "download-export", to: "core_induction_programmes#download_export", as: :download_export

  scope path: "/", module: :core_induction_programmes do
    resources :years, only: %i[show new create edit update]

    resources :modules, only: %i[show edit update]
    resources :lessons, only: %i[show edit update]

    resources :lesson_parts, only: %i[show edit update destroy] do
      get "split", to: "lesson_parts#show_split", as: "split"
      post "split", to: "lesson_parts#split"
      get "show_delete", to: "lesson_parts#show_delete"
      put "update-progress", to: "lesson_parts#update_progress", as: :update_progress
    end

    resources :mentor_materials, path: "mentor-materials", only: %i[show index edit update new create]
    resources :mentor_material_parts, path: "mentor-material-parts", only: %i[show edit update show_delete destroy] do
      get "show_delete", to: "mentor_material_parts#show_delete"
    end
  end
  root to: "start#index"

  get "training-and-support" => "training_and_support#show"
end
