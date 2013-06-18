require 'spec_helper'

describe Offer do
  before :each do
    Event.destroy_all
    Place.destroy_all
    Offer.destroy_all
  end

  #  attr_accessible :currency, :description, :end_time, :name, :price, :start_time
  it 'should be possible to create an offer with spefified data' do
    offer = Offer.new :currency => 'EUR', :description => 'desc', :name => 'name', :price => 22.22, :start_time => Time.now, :end_time => Time.now
    offer.save!
    offer.currency.should eq('EUR')
    offer.description.should eq('desc')
    offer.name.should eq('name')
    offer.price.should eq(22.22)
    #TODO: add time assignment test comparisong Time.now fails due to difference between asignment and test time
  end

  it 'should be possible to create an offer with a place' do
    offer = Offer.new
    place = Place.new
    offer.offerer = place
    place.save!
    offer.save!
    offer.offerer.should equal(place)
    place.offers.should include(offer)
  end

  it 'should be possible to create an offer with an event' do
    offer = Offer.new
    event = Event.new
    offer.offerer = event
    event.save!
    offer.save!
    offer.offerer.should equal(event)
    event.offers.should include(offer)
  end

end