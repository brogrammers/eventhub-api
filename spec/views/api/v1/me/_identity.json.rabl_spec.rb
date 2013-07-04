require 'spec_helper'

describe 'api/v1/me/_identity' do
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
    render_me_identity_view_json
  end

  context 'rendered' do

    it 'id' do
      key_is_an_integer?('id').should == true
    end

    it 'provider' do
      key_is_a_string?('provider').should == true
    end

    it 'provider_id' do
      key_is_a_string?('provider_id').should == true
    end

  end


end