Rails.application.routes.draw do
  scope module: :users do 
    devise_for :users, controllers: {
      sessions: "public/users/sessions",
      registrations: "public/users/registrations"
    }
  end
  root "homes#top"
  get "/about", to: "homes#about"
  get "/howto", to: "homes#howto"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
