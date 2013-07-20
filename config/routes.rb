EventhubApi::Application.routes.draw do
  use_doorkeeper

  namespace :api do
    namespace :v1 do
      resources :me, :only => [:index]
      resources :groups do
        resources :members, :controller => 'group_members'
        resources :invited, :controller => 'group_pending_memebrs'
        resources :messages, :controller =>'group_messages'
      end
    end
  end
end
