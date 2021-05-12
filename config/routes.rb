# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, skip: :registrations, controllers: {
    sessions: "users/sessions",
    confirmations: "users/confirmations",
  }
  get "signed_out" => "signed_out#show"

  get "check" => "application#check"

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
  end
  root to: "start#index"

  get "training-and-support" => "training_and_support#show"
end
