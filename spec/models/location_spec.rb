require 'spec_helper'

describe Location do
  fixtures :locations

  context 'invalid' do

    before :all do
      class Location
        def find_location

        end
      end
    end

    it 'should not be possible to create an invalid location object' do
      location = Location.new :latitude => 53.344103999999990000, :longitude => -6.267493699999932000
      expect { location.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

  context 'valid' do

    before :all do
      class Location
        def find_location
          self.city = 'some_city'
          self.country = 'some_country'
        end
      end
    end

    it 'should be possible to create a valid location object' do
      location = Location.new :latitude => 53.344103999999990000, :longitude => -6.267493699999932000
      location.save!.should be_true
      location.city.should == 'some_city'
      location.country.should == 'some_country'
    end

  end

end