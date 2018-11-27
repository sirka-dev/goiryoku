Rails.application.routes.draw do
  root to: 'tweets#index'
  get 'tweets/index'
  get 'tweets/timeline'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
