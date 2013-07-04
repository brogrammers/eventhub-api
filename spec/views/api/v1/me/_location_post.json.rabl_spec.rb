require 'spec_helper'

describe 'api/v1/me/_location_post' do
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
    render_me_location_post_view_json
  end

  context 'rendered' do

    it 'content' do
      key_is_a_string?('content').should == true
    end

    it 'location' do
      key_is_a_hash?('location').should == true
    end

  end


end