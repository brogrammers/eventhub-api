require 'spec_helper'

describe Event do
  fixtures :events, :comments, :offers

  it 'should be possible to comment on an event' do
    event = events :one
    comment = comments :one
    event.comments << comment
    comment.save!
    event.save!
    event.comments.size.should == 1
  end

  it 'should destroy all comments of an event once the event is destroyed' do
    event = events :one
    comment = comments :one
    event.comments << comment
    comment.save!
    event.save!
    event.destroy
    Comment.all.size.should == 0
  end

  it 'should be possible to add an offer to an event' do
    event = events :one
    offer1, offer2 = offers(:one), offers(:two)
    event.offers << offer1
    event.offers << offer2
    event.save!
    offer1.save!
    offer2.save!
    event.offers.should include(offer1)
    event.offers.should include(offer2)
    offer1.offerer.should == event
    offer2.offerer.should == event
  end

  it 'should be possible to remove an offer from an event' do
    event = events :one
    offer1, offer2 = offers(:one), offers(:two)
    event.offers << offer1
    event.offers << offer2
    event.save!
    offer1.save!
    offer2.save!
    event.offers.delete offer1
    event.offers.delete offer2
    event.offers.size.should == 0
  end

  it 'should destroy all offers of an event once the event is destroyed' do
    event = events :one
    offer1, offer2 = offers(:one), offers(:two)
    event.offers << offer1
    event.offers << offer2
    event.save!
    offer1.save!
    offer2.save!
    event.destroy
    expect { Offer.find offer1.id; Offer.find offer2.id }.to raise_error(ActiveRecord::RecordNotFound)
  end
end