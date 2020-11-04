Rails.application.routes.draw do

  scope module: :public do 
    devise_for :users, controllers: {
      sessions: "public/users/sessions",
      registrations: "public/users/registrations"
    }
    resources :users
    post "users/follow/:id", to: "users#follow", as: "users_follow"
    delete "users/unfollow/:id", to: "users#unfollow", as: "users_unfollow"
    
    resources :words
    
    resource :dictionary, only: [:show, :create]
    get "dictionary/words", to: "dictionaries#words", as: "dictionary_words"
    get "dictionary/choose", to: "dictionaries#choose", as: "dictionary_choose"
    get "dictionary/question", to: "dictionaries#question", as: "dictionary_question"
    post "dictionary/check", to: "dictionaries#check", as: "dictionary_check"
    get "dictionary/result",to: "dictionaries#result", as: "dictionary_result"
    post "dictionary/words/:id", to: "dictionaries#add", as: "dictionary_add"
    delete "dictionary/words/:id", to: "dictionaries#remove", as: "dictionary_remove"
    
  end
  
  root "homes#top"
  get "/about", to: "homes#about"
  get "/howto", to: "homes#howto"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
