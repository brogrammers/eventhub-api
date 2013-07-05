require 'spec_helper'

describe 'api/v1/places/creator' do
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
    render_places_creator_view_json
  end

  context 'rendered' do

    it 'id' do
      key_is_an_integer?('id').should == true
    end

    it 'name' do
      key_is_a_string?('name').should == true
    end

  end

end