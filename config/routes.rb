Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions: "admin/admins/sessions"
  }
  devise_for :users, controllers: {
    sessions: "public/users/sessions",
    registrations: "public/users/registrations"
  }
  namespace :admin do
    get "/", to: "homes#top", as: "top"
    resources :users do
      member do
        resource :dictionary, only: :show, as: "user_dictionary"
      end
      collection do
        match "search", to: "users#search", via: [:get, :post], as: "search" 
        get "today"
      end
    end
    resources :words do
      collection do
        match "search", to: "words#search", via: [:get, :post], as: "search" 
        get "today"
      end
    end
  end
  
  scope module: :public do  
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
  end

  root "homes#top"
  get "/about", to: "homes#about"
  get "/howto", to: "homes#howto"
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
