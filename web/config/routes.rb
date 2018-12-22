Rails.application.routes.draw do
  resources :lives
  root to: 'tweets#index'
  get 'tweets/index'
  get 'tweets/timeline'
  get 'tweets/goiryoku'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
