Rails.application.routes.draw do

  scope module: :public do 
    devise_for :users, controllers: {
      sessions: "public/users/sessions",
      registrations: "public/users/registrations"
    }
    resources :users
    resources :words
    resource :dictionary, only: [:show]
    get "dictionary/question"
    post "dictionary/check"
    get "dictionary/result"
    post "dictionary/words/:id", to: "dictionary#add"
    delete "dictionary/words/:id", to: "dictionary#remove"
  end
  root "homes#top"
  get "/about", to: "homes#about"
  get "/howto", to: "homes#howto"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
