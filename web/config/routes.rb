Rails.application.routes.draw do
  resources :lives
  root to: 'goiryoku#index'
  get 'tweets/index'
  get 'tweets/timeline'
  get 'goiryoku/index'
  get 'goiryoku/goiryoku'
end
