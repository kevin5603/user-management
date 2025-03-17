# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get 'access_denied.html.erb', to: 'errors#access_denied', as: :access_denied
  get 'home/index'

  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'register',
    sign_up: 'sign_up'
  }
  resources :users
  root to: 'home#index'
end
