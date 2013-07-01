require 'spec_helper'

describe Event do
  fixtures :events, :comments, :offers, :places, :destinations

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

  context 'Destinations' do
    it 'should be possible to add destination to event' do
      event = events :one
      dest = destinations :one
      event.destinations << dest
      dest.save!
      event.save!
      event.destinations.should include(dest)
      dest.choice.should == event
    end

    it 'when event is destroyed it should destroy all destinations which have this place as their choice' do
      event = events :one
      dest = destinations :one
      event.destinations << dest
      dest.save!
      event.save!
      event.destroy
      expect{ Destination.find dest.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'Validations' do

    it 'should not be possible to create event without description' do
      event = events :one
      event.description = nil
      expect{ event.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event without name' do
      event = events :one
      event.name = nil
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event without start time' do
      event = events :one
      event.start_time = nil
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event without end time' do
      event = events :one
      event.end_time = nil
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event without place' do
      event = events :one
      event.place = nil
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event name containing less than 5 characters' do
      event = events :one
      event.name = 'abcd'
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event name containing more than 256 characters' do
      event = events :one
      event.name = Array.new(257){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event description containing less than 5 characters' do
      event = events :one
      event.description = 'abcd'
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event description containing more than 1024 characters' do
      event = events :one
      event.description = Array.new(1025){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create event which starts in the past' do
      event = events :one
      event.start_time = Time.now - 1
      expect{ event.save!}.to raise_error(ActiveRecord::RecordInvalid)
      event.errors.full_messages.first.should == "Start time #{I18n.translate!('activerecord.errors.models.event.attributes.start_time.in_future')}"
    end

    it 'should not be possible to crate event which ends before it starts' do
      event = events :one
      event.end_time = event.start_time - 1
      expect{ event.save! }.to raise_error(ActiveRecord::RecordInvalid)
      event.errors.full_messages.first.should == "End time #{I18n.translate!('activerecord.errors.models.event.attributes.end_time.after_start_time')}"
    end

    it 'should not be possible to create event with type other than private / public / certified' do
      event = events :one
      event.visibility_type = 'abc'
      expect{ event.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end