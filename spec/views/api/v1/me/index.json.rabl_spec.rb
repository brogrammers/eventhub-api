require 'spec_helper'

describe 'api/v1/me/index' do
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
    render_me_index_view_json
  end

  context 'rendered' do

    it 'id' do
      key_is_an_integer?('id').should == true
    end

    it 'name' do
      key_is_a_string?('name').should == true
    end

    it 'availability' do
      key_is_boolean?('availability').should == true
    end

    it 'location' do
      key_is_a_hash?('location').should == true
    end

    it 'groups_created' do
      key_is_an_array?('groups_created').should == true
    end

    it 'groups_member_of' do
      key_is_an_array?('groups_member_of').should == true
    end

    it 'groups_invited_to' do
      key_is_an_array?('groups_invited_to').should == true
    end

    it 'places' do
      key_is_an_array?('places').should == true
    end

    it 'location_posts' do
      key_is_an_array?('location_posts').should == true
    end

    it 'devices' do
      key_is_an_array?('devices').should == true
    end

    it 'notifications' do
      key_is_an_array?('notifications').should == true
    end

    it 'identities' do
      key_is_an_array?('identities').should == true
    end

  end

end