require 'spec_helper'

describe 'api/v1/me/_notification' do
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
    render_me_notification_view_json
  end

  context 'rendered' do

    it 'title' do
      key_is_a_string?('title').should == true
    end

    it 'read' do
      key_is_boolean?('read').should == true
    end

    it 'payload' do
      # TODO: Has to be a Hash at some point
      key_is_a_string?('payload').should == true
    end

  end


end