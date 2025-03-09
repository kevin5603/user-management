# frozen_string_literal: true

Rails.application.routes.draw do
  # devise_for :users, controllers: {
  #   registrations: 'device/registrations',
  #   sessions: 'device/sessions'
  # }

  devise_for :users
  resources :users
  root to: 'users#index'
end
