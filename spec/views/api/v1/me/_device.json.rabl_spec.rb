require 'spec_helper'

describe 'api/v1/me/_device' do
  fixtures :core_users,
           :users,
           :business_users,
           :location_posts,
           :locations,
           :places,
           :events,
           :identities,
           :devices,
           :groups,
           :notifications,
           :messages,
           :devices,
           :destinations,
           :chatrooms,
           :comments

  before :each do
    render_me_devices_view_json
  end

  context 'rendered' do

    it 'name' do
      key_is_a_string?('name').should == true
    end

    it 'token' do
      key_is_a_string?('token').should == true
    end

  end

end