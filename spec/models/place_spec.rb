require 'spec_helper'

describe Place do
  fixtures :places, :comments, :offers

  it 'should possible to comment on a place' do
    place = places :one
    comment = comments :one
    place.comments << comment
    comment.save!
    place.save!
    place.comments.size.should == 1
  end

  it 'should destroy all comments on that place when the place is destroyed' do
    place = places :one
    comment = comments :one
    place.comments << comment
    comment.save!
    place.save!
    place.destroy
    expect { Comment.find comment.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

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

  it 'should destroy offers when the place is destroyed' do
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
