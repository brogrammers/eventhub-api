require 'spec_helper'

describe Offer do
  fixtures :offers, :places, :events

  it 'should be possible to create an offer with a place' do
    offer = offers :one
    place = places :one
    offer.offerer = place
    place.save!
    offer.save!
    offer.offerer.should equal(place)
    place.offers.should include(offer)
  end

  it 'should be possible to create an offer with an event' do
    offer = offers :one
    event = events :one
    offer.offerer = event
    event.save!
    offer.save!
    offer.offerer.should equal(event)
    event.offers.should include(offer)
  end

end