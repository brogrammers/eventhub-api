EventhubApi::Application.routes.draw do

  apipie
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      get '/me', :to => 'me#index'
      put '/me', :to => 'me#update'
      resources :places, :only => [:index, :show, :create, :update, :destroy]
    end
  end
end
