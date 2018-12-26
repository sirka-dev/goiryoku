Rails.application.routes.draw do
  resources :lives
  root to: 'goiryoku#index'
  resources :tweets, only: [:index] do
    collection { post :import }
  end
  get 'goiryoku/index'
  get 'goiryoku/goiryoku'
end
