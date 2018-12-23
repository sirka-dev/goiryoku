Rails.application.routes.draw do
  resources :lives
  root to: 'tweets#index'
  get 'tweets/index'
  get 'tweets/timeline'
  get 'goiryoku/index'
end
