Hai::Rest::Engine.routes.draw do
  get "/:model", to: "rest#index"
  get "/:model/:id", to: "rest#show"
  post "/:model", to: "rest#create"
  put "/:model/:id", to: "rest#update"
  delete "/:model/:id", to: "rest#destroy"
end
