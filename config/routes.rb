# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/index'
  devise_for :users
  resources :users
  root to: 'home#index'
end
