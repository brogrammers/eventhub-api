require 'spec_helper'

describe Place do
  fixtures :core_users, :users, :places, :comments, :offers, :events, :locations

  context '#all_within' do

    it 'should query all places within a location' do
      Place.all_within(53.344103999999990000, -6.267493699999932000, 1).size.should == 1
    end
  end

  context 'comment' do

    it 'should possible to comment on a place' do
      place = places :one
      comment = comments :one
      comment.user = users :one
      place.comments << comment
      comment.save!
      place.save!
      place.comments.size.should == 1
    end

    it 'should destroy all comments on that place once the place is destroyed' do
      place = places :one
      comment = comments :one
      comment.user = users :one
      place.comments << comment
      comment.save!
      place.save!
      place.destroy
      expect { Comment.find comment.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  context 'offers' do

    it 'should be possbile to add an offer' do
      place = places :one
      offer1, offer2 = offers(:one), offers(:two)
      place.offers << offer1
      place.offers << offer2
      place.save!
      offer1.save!
      offer2.save!
      place.offers.should include(offer1)
      place.offers.should include(offer2)
      offer1.offerer.should == place
      offer2.offerer.should == place
    end

    it 'should be possible to remove an offer' do
      place = places :one
      offer1, offer2 = offers(:one), offers(:two)
      place.offers << offer1
      place.offers << offer2
      place.save!
      offer1.save!
      offer2.save!
      place.offers.delete offer1
      place.offers.delete offer2
      place.offers.size.should == 0
    end

    it 'should destroy offers once the place is destroyed' do
      place = places :one
      offer1, offer2 = offers(:one), offers(:two)
      place.offers << offer1
      place.offers << offer2
      place.save!
      offer1.save!
      offer2.save!
      place.destroy
      expect { Offer.find offer1.id; Offer.find offer2.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  context 'events' do

    it 'should be possible to add event to a place' do
      place = places :one
      event = events :one
      place.events << event
      place.save!
      event.save!
      place.events.should include(event)
      event.place.should == place
    end

    it 'should be possible to remove event from a place' do
      place = places :one
      event = events :one
      place.events << event
      event.save!
      place.save!
      place.events.delete event
      place.save!
      place.events.should_not include(event)
    end

    it 'should destoy all events when place is destroyed' do
      place = places :one
      event = events :one
      place.events << event
      event.save!
      place.save!
      place.destroy
      expect{ Event.find event.id }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'validations' do

    it 'should not be possible to ceate a place with description' do
      place = places :one
      place.description = nil
      expect{ place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a place without name' do
      place = places :one
      place.name = nil
      expect{ place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a place without location' do
      place = places :one
      place.location = nil
      expect{ place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create place with a name with less than 5 characters' do
      place = places :one
      place.name = 'abcd'
      expect{ place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create place with a name with more than 265 characters' do
      place = places :one
      place.name = Array.new(257){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      expect { place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a place with description with less than 5 characters' do
      place = places :one
      place.description = 'abcd'
      expect{ place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a place with description with more than 1024 characters' do
      place = places :one
      place.description = Array.new(1025){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
      expect{ place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a place with type other than private / public / certified' do
      place = places :one
      expect { place.visibility_type = :invalid }.to raise_error(ArgumentError)
    end

    it 'should not be possible to create a place without any type' do
      place = places :three
      expect { place.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

  end

end
