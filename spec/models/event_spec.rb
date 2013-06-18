require 'spec_helper'

describe Event do

  before :each do
    Event.destroy_all
    Comment.destroy_all
    Offer.destroy_all
  end

  it 'should possible to comment on an event' do
    event = Event.new
    comment = Comment.new
    event.comments << comment
    comment.save!
    event.save!
    event.comments.size.should eq(1)
  end

  it 'should destroy all comments on that event when the event is destroyed' do
    event = Event.new
    comment = Comment.new
    event.comments << comment
    comment.save!
    event.save!
    event.destroy
    Comment.all.size.should eq(0)
  end

  it 'should be possbile to add an offer' do
    event = Event.new
    offer1 = Offer.new
    offer2 = Offer.new
    event.offers << offer1
    event.offers << offer2
    event.save!
    offer1.save!
    offer2.save!
    event.offers.should include(offer1)
    event.offers.should include(offer2)
    offer1.offerer.should eq(event)
    offer2.offerer.should eq(event)
  end

  it 'should be possible to remove an offer' do
    event = Event.new
    offer1 = Offer.new
    offer2 = Offer.new
    event.offers << offer1
    event.offers << offer2
    event.save!
    offer1.save!
    offer2.save!
    event.offers.delete offer1
    event.offers.delete offer2
    event.offers.size.should eq(0)
  end

  it 'should destroy events when the place is destroyed' do
    offer = Event.new
    offer1 = Offer.new
    offer2 = Offer.new
    offer.offers << offer1
    offer.offers << offer2
    offer.save!
    offer1.save!
    offer2.save!
    offer.destroy
    Offer.all.size.should eq(0)
  end
end