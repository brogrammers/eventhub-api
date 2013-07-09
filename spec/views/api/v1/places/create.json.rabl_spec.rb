require 'spec_helper'

describe 'api/v1/places/create' do
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
    render_places_create_view_json
  end

  context 'rendered' do

    it 'id' do
      key_is_an_integer?('id').should == true
    end

    it 'name' do
      key_is_a_string?('name').should == true
    end

    it 'visibility_type' do
      key_is_a_string?('visibility_type').should == true
    end

    it 'location' do
      key_is_a_hash?('location').should == true
    end

    it 'creator' do
      key_is_a_hash?('creator').should == true
    end

    it 'comments' do
      key_is_an_array?('comments').should == true
    end

  end

end