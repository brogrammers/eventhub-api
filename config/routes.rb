EventhubApi::Application.routes.draw do

  apipie
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :me, :only => [:index]
    end
  end
end
