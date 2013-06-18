require 'spec_helper'

describe Event do

  before :each do
    Event.destroy_all
    Comment.destroy_all
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
end