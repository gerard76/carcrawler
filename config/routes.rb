Rails.application.routes.draw do
  root to: "cars#index"
  resources :cars
end
