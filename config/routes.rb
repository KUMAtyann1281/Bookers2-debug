Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users
  root to: "homes#top"
  get "home/about"=>"homes#about", as: "about"
  get "/search"=>"searches#search"

  resources :users, only: [:index,:show,:edit,:update] do
    resource :favorites, only: [:create, :destroy]
    resource :relationships, only: [:create, :destroy]
    get "followers" => "relationships#followers", as: "followers"
    get "following" => "relationships#following", as: "following"
    get "posts_on_date" => "users#posts_on_date"
  end

  resources :groups, only: [:new, :index, :show, :create, :edit, :update] do
    resource :group_users, only: [:create, :destroy]
    resources :event_notices, only: [:new, :create]
    get "event_notices" => "event_notices#sent"
  end

  resources :rooms, only: [:create,:show]
  resources :messages, only: [:create]

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resource :favorite, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
