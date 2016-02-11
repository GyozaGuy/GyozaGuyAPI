require 'api_constraints'

Rails.application.routes.draw do
  mount SabisuRails::Engine => "/sabisu_rails"
  devise_for :users
  # API definition
  namespace :api, defaults: { format: :json }, path: '/api' do # constraints: { subdomain: 'api' }
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :posts, only: [:create, :update, :destroy]
      end
      resources :sessions, only: [:create, :destroy]
      resources :posts, only: [:index, :show]
    end
  end
end
