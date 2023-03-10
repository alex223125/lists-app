Rails.application.routes.draw do
  resources :items
  resources :lists
  devise_for :users,
             controllers: {
               sessions: 'users/sessions',
               registrations: 'users/registrations'
             }
  devise_scope :user do
    get '/user-data', to: 'users/sessions#user_by_token'
  end
end
