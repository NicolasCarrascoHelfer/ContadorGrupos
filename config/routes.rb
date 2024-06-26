Rails.application.routes.draw do
  #get 'pages/home'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  #get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  get "count/:id", to: "pages#count", as: "group"
  put "groups/:id/next", to: "groups#next", as: "next"
  put "groups/:id/reset", to: "groups#reset", as: "reset"
  root "pages#home"
end
