require 'spec_helper'

describe Destination do

  after :each do
    Destination.destroy_all
    Group.destroy_all
    User.destroy_all
    Event.destroy_all
    Place.destroy_all
  end

  it 'should have a creator' do
    dest = Destination.new
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    user.save!
    dest.creator = user
    dest.save!
    dest.creator.should equal(user)
  end

  it 'should have voters' do
    dest = Destination.new
    user1 = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    user2 = User.new :name => 'Rob', :availability => true, :registered => true, :registered_at => Time.now
    dest.voters << user1
    dest.voters << user2
    user1.save!
    user2.save!
    dest.save!
    dest.voters.size.should eq(2)
  end

  it 'should belong to a group' do
    dest = Destination.new
    group = Group.new
    dest.group = group
    group.save!
    dest.save!
    dest.group.should equal(group)
    group.destinations.size.should eq(1)
  end

  it 'should destroy votes when destination is destoyed' do
    dest = Destination.new
    user1 = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    user2 = User.new :name => 'Rob', :availability => true, :registered => true, :registered_at => Time.now
    dest.voters << user1
    dest.voters << user2
    user1.save!
    user2.save!
    dest.save!
    dest.destroy
    Vote.all.size.should eq(0)
  end

  it 'should add event to choice' do
    dest = Destination.new
    event = Event.new
    dest.save!
    event.save!
    dest.choice = event
    dest.save!
    dest.choice.should equal(event)
    event.destinations.size.should eq(1)
  end

  it 'should add place to choice' do
    dest = Destination.new
    place = Place.new
    dest.save!
    place.save!
    dest.choice = place
    dest.save!
    dest.choice.should equal(place)
    place.destinations.size.should eq(1)
  end

end
