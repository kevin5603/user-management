# frozen_string_literal: true
require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'access_denied.html.erb', to: 'errors#access_denied', as: :access_denied
  get 'home/index'
  devise_for :users
  resources :users
  root to: 'home#index'
end
