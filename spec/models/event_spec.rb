require 'spec_helper'

describe Event do
  fixtures :events, :comments, :offers, :places

  context 'Comments' do

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

  end

  context 'Offers' do

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

  context 'Validations' do
    it 'should not be possible to create event without description' do

    end

    it 'should not be possible to create event without name' do

    end

    it 'should not be possible to create event without start time' do

    end

    it 'should not be possible to create event without end time' do

    end

    it 'should not be possible to create event without place' do

    end

    it 'should not be possible to create event name containing less than 5 characters' do

    end

    it 'should not be possible to create event name containing more than 256 characters' do

    end

    it 'should not be possible to create event descripion containing less than 5 characters' do

    end

    it 'should not be possible to create event description containing more than 1024 charcters' do

    end

    it 'should not be possible to create event which starts in the past' do

    end

    it 'should not be possible to crate event which ends before it starts' do

    end


  end

end