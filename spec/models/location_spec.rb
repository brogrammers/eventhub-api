require 'spec_helper'

describe Location do
  fixtures :locations

  Geocoder.configure(:lookup => :test)

  context '#all_within' do

    LATITUDE  = 55.12345678
    LONGITUDE = 55.3456783

    before :all do
      Geocoder::Lookup::Test.set_default_stub(
        [
          {
            'latitude'     => LATITUDE,
            'longitude'    => LONGITUDE,
            'city'         => 'some_city',
            'country'      => 'some_country'
          }
        ]
      )
    end

    it 'should query all locations within a location' do
      Location.create! :latitude => LATITUDE,     :longitude => LONGITUDE
      Location.create! :latitude => LATITUDE,     :longitude => LONGITUDE
      Location.create! :latitude => LATITUDE,     :longitude => LONGITUDE
      Location.create! :latitude => LATITUDE + 1, :longitude => LONGITUDE + 1
      Location.create! :latitude => LATITUDE + 1, :longitude => LONGITUDE + 1
      Location.all_within(LATITUDE, LONGITUDE, 1).size.should == 3
    end

  end

  context 'invalid' do

    before :all do
      Geocoder::Lookup::Test.set_default_stub([{}])
    end

    it 'should not be possible to create an invalid location object' do
      location = locations :without_city_and_country
      location.valid?.should == false
      expect { location.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  context 'valid' do

    before :all do
      Geocoder::Lookup::Test.set_default_stub(
        [
          {
            'latitude'     => 53.344103999999990000,
            'longitude'    => -6.267493699999932000,
            'city'         => 'some_city',
            'country'      => 'some_country'
          }
        ]
      )
    end

    it 'should be possible to create a valid location object' do
      location = locations :without_city_and_country
      location.valid?.should == true
      location.city.should == 'some_city'
      location.country.should == 'some_country'
    end

  end

end