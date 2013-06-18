require 'spec_helper'

describe User do
  fixtures :users, :core_users

  LATITUDE  = 53.344103999999990000
  LONGITUDE = -6.267493699999932000

  it 'should not create a new invalid user record' do
    user = User.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not pass validation for a new invalid user record' do
    user = User.new
    user.valid?.should be_false
  end

  it 'should add a valid location to a user record' do
    user = users(:one)
    user.location = Location.create :latitude => LATITUDE, :longitude => LONGITUDE
    user.save!
    user.location.latitude.should == LATITUDE
    user.location.longitude.should == LONGITUDE
  end

end