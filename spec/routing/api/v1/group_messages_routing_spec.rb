require 'spec_helper'

describe 'routing to group messages' do
  it 'routes to #index' do
    {:get => '/api/v1/groups/1/messages'}.should route_to(:controller => 'api/v1/group_messages', :action => 'index', 'group_id' => '1')
  end

  it 'routes to #show' do
    {:get => '/api/v1/groups/1/messages/1'}.should route_to(:controller => 'api/v1/group_messages', :action => 'show', 'group_id' => '1', 'id' => '1')
  end

  it 'routes to #create' do
    {:post => '/api/v1/groups/1/messages'}.should route_to(:controller => 'api/v1/group_messages', :action => 'create', 'group_id' => '1')
  end
end