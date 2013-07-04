require 'spec_helper'

describe 'api/v1/me/_place' do
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
    render_me_place_view_json
  end

  context 'rendered' do

    it 'name' do
      key_is_a_string?('name').should == true
    end

    it 'description' do
      key_is_a_string?('description').should == true
    end

    it 'location' do
      key_is_a_hash?('location').should == true
    end

  end


end