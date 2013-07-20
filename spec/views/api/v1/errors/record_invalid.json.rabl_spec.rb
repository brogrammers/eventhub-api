require 'spec_helper'

describe 'api/v1/errors/record_invalid' do
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
    render_errors_record_invalid
  end

  context 'rendered' do

    it 'messages' do
      key_is_an_array?('messages').should == true
    end

  end

end