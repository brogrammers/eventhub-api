require 'spec_helper'

describe Place do

  before :each do
    Place.destroy_all
    Comment.destroy_all
    Offer.destroy_all
  end

  it 'should possible to comment on a place' do
    place = Place.new
    comment = Comment.new
    place.comments << comment
    comment.save!
    place.save!
    place.comments.size.should eq(1)
  end

  it 'should destroy all comments on that place when the place is destroyed' do
    place = Place.new
    comment = Comment.new
    place.comments << comment
    comment.save!
    place.save!
    place.destroy
    Comment.all.size.should eq(0)
  end

  it 'should be possbile to add an offer' do
    place = Place.new
    offer1 = Offer.new
    offer2 = Offer.new
    place.offers << offer1
    place.offers << offer2
    place.save!
    offer1.save!
    offer2.save!
    place.offers.should include(offer1)
    place.offers.should include(offer2)
    offer1.offerer.should eq(place)
    offer2.offerer.should eq(place)
  end

  it 'should be possible to remove an offer' do
    place = Place.new
    offer1 = Offer.new
    offer2 = Offer.new
    place.offers << offer1
    place.offers << offer2
    place.save!
    offer1.save!
    offer2.save!
    place.offers.delete offer1
    place.offers.delete offer2
    place.offers.size.should eq(0)
  end

  it 'should destroy offers when the place is destroyed' do
    place = Place.new
    offer1 = Offer.new
    offer2 = Offer.new
    place.offers << offer1
    place.offers << offer2
    place.save!
    offer1.save!
    offer2.save!
    place.destroy
    Offer.all.size.should eq(0)
  end

end
