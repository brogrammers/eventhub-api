require 'spec_helper'

describe Location do
  fixtures :locations

  it 'should not be possible to create an invalid location object' do
    location1 = Location.new
    location2 = Location.new
    location1.latitude = 1234567890
    location1.longitude = 1234567890
    location2.latitude = -1234567890
    location2.longitude = -1234567890
    location1.valid?.should be_false
    location2.valid?.should be_false
  end

end