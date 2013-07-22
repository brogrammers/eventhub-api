require 'spec_helper'

describe 'api/v1/errors/not_privileged_error' do
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
    render_errors_not_privileged_error
  end

  context 'rendered' do

    it 'messages' do
      key_is_an_array?('messages').should == true
    end

  end

end