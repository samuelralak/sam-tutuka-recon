# frozen_string_literal: true

Rails.application.routes.draw do
  resources :csv_files, only: :create
  resources :csv_comparator, only: :create
  resources :reports, only: :create do
    post :matches, on: :collection
  end

  root 'home#index'
end
