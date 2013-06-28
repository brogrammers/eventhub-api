require 'spec_helper'

describe Destination do
  fixtures :core_users, :users, :destinations, :groups, :events, :places, :chatrooms

  it 'should have a creator' do
    dest = destinations :one
    dest.creator = users :one
    dest.save!
    dest.creator.should equal(users(:one))
  end

  it 'should have voters' do
    dest = destinations :one
    dest.voters << users(:one)
    dest.voters << users(:two)
    dest.save!
    dest.voters.size.should == 2
  end

  it 'should belong to a group' do
    dest = destinations :one
    group = groups :one
    dest.group = group
    group.save!
    dest.save!
    dest.group.should equal(group)
    group.destinations.size.should == 1
  end

  it 'should destroy votes when destination is destroyed' do
    dest = destinations :one
    dest.voters << users(:one)
    dest.voters << users(:two)
    dest.save!
    dest.destroy
    Vote.all.size.should == 0
  end

  it 'should add event to choice' do
    dest = destinations :one
    event = events :one
    dest.choice = event
    dest.save!
    dest.choice.should equal(event)
    event.destinations.size.should == 1
  end

  it 'should add place to choice' do
    dest = destinations :one
    place = places :one
    dest.choice = place
    dest.save!
    dest.choice.should equal(place)
    place.destinations.size.should == 1
  end

end
