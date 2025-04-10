Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :products

      post "register", to: "authentication#register"
      post "login", to: "authentication#login"
    end
  end
end
