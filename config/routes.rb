Rails.application.routes.draw do
  resources :lives
  root to: 'goiryoku#index'
  get 'tweets/index'
  get 'tweets/csv_parse'
  get 'goiryoku/index'
  get 'goiryoku/goiryoku'
end
