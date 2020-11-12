Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  scope module: :public do 
    devise_for :users, controllers: {
      sessions: "public/users/sessions",
      registrations: "public/users/registrations"
    }
    resources :users do
      collection do
        match 'search' => "users#search", via: [:get, :post], as: :search
      end
      member do
        get "followers"
        get "followings"
        post "follow"
        delete "unfollow"
      end
    end

    resources :words do
      collection do
        get "tagged_words/:tag", to: "words#tagged_words", as: "tagged"
        match 'search' => 'words#search', via: [:get, :post], as: :search
        get "/by_name/:name", to: "words#same_name", as: "same_name"
        get "/by_meaning/:meaning", to: "words#same_meaning", as: "same_meaning"
        get "tags", to: "words#tags", as: "tags"
      end
    end

    resource :dictionary, only: [:show, :create] do
      collection do
        get "words"
        get "choose"
        match "question", to: "dictionaries#question", via: [:get, :post], as: "question"
        post "check"
        get "result"
        post "words/:id", to: "dictionaries#add", as: "add"
        delete "words/:id", to: "dictionaries#remove", as: "remove"
      end
    end
    # post "dictionary/words/:id", to: "dictionaries#add", as: "dictionary_add"
    # delete "dictionary/words/:id", to: "dictionaries#remove", as: "dictionary_remove"
    
  end
  
  root "homes#top"
  get "/about", to: "homes#about"
  get "/howto", to: "homes#howto"
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
