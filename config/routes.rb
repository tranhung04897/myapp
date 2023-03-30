Rails.application.routes.draw do
  get 'healthcheck', to: proc { [200, {}, ['']] }

  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions',
  }
  devise_scope :user do
    post 'users/sign_up', to: 'devise/registrations#create'
    get 'users/:id/edit', to: 'users/registrations#edit', as: :edit_other_user_registration
    match 'users/:id', to: 'users/registrations#update', via: [:patch, :put], as: :other_user_registration
    delete 'users/:id', to: 'users/registrations#destroy', as: :destroy_other_user_registration
  end

  # Defines the root path route ("/")
  root "homes#dashboard"
  resources :users, only: [:index]
  resources :osi_cas do
    collection do
      delete :delete_osis
    end
  end
  resources :osi_bookers do
    collection do
      delete :delete_osis
    end
  end
  resources :order_infomations do
    collection do
      post   :import
      get    :export
      delete :delete_order
      get    :download
      post   :download_data
      post   :update_order
      get    :ajax_download_data
    end
  end
  delete '/delete_users', to: 'users#delete_users'
  resources :tracking_histories, only: [:index, :show]
end
