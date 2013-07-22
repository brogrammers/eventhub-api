require 'spec_helper'

describe 'api/v1/places/comment' do
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
    render_places_comment_view_json
  end

  context 'rendered' do

    it 'id' do
      key_is_an_integer?('id').should == true
    end

    it 'content' do
      key_is_a_string?('content').should == true
    end

    it 'rating' do
      key_is_an_integer?('rating').should == true
    end

  end

end