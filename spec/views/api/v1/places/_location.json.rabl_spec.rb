require 'spec_helper'

describe 'api/v1/places/location' do
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
    render_places_location_view_json
  end

  context 'rendered' do

    it 'latitude' do
      key_is_a_float?('latitude').should == true
    end

    it 'longitude' do
      key_is_a_float?('longitude').should == true
    end

    it 'city' do
      key_is_a_string?('city').should == true
    end

    it 'country' do
      key_is_a_string?('country').should == true
    end

  end

end