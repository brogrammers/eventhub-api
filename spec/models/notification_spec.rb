require 'spec_helper'

describe Notification do
  fixtures :notifications

  it 'should hashify the payload' do
    notification = notifications :one
    notification.payload_hash.class.should == Hash
  end

end