Rails.application.routes.draw do
  root 'welcome#index'

  controller :welcome do
    post :feedback
    post :change_locale
  end

  controller :dashboard do
    get :dashboard, action: :index
    get :profile
  end

  namespace :users do
    resources :profile, only: [:edit, :update] do
      member do
        patch :update_password
        patch :update_avatar
      end
    end
  end

  resources :articles, only: [:new, :create, :show, :edit, :update, :destroy]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  devise_scope :user do
    get 'users/twitter_email' => "users/registrations#twitter_email"
    post 'users/twitter_create' => "users/omniauth_callbacks#twitter_create"
  end

  if Rails.env.development? || Rails.env.staging?
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
