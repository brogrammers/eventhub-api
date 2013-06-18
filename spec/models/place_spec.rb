require 'spec_helper'

describe Place do

  before :each do
    Place.destroy_all
    Comment.destroy_all
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
end
