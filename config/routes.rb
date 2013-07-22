EventhubApi::Application.routes.draw do

  apipie
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :me, :only => [:index]
      resources :places, :only => [:index, :show, :create, :update, :destroy]
    end
  end
end
