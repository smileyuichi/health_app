Rails.application.routes.draw do
  devise_for :users
  root 'weights#index'
  resource :weights, only: %i[index create update]
end
