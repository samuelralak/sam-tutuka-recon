# frozen_string_literal: true

Rails.application.routes.draw do
  resources :csv_files, only: :create
  resources :csv_comparator, only: :create
  resources :reports, only: :create
  root 'home#index'
end
