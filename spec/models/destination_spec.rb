require 'spec_helper'

describe Destination do
  fixtures :core_users, :users, :destinations, :groups, :events, :places, :chatrooms

  it 'should have a creator' do
    dest = destinations :without_creator
    user = users :one
    dest.creator = user
    user.save!
    dest.save!
    dest.creator.should equal(users(:one))
  end

  it 'should have voters' do
    dest = destinations :valid_destination
    dest.voters << users(:three)
    dest.voters << users(:four)
    dest.group.members << users(:three)
    dest.group.members << users(:four)
    dest.save!
    dest.voters.size.should == 2
  end

  it 'should belong to a group' do
    dest = destinations :without_group
    group = groups :four
    dest.group = group
    group.save!
    dest.save!
    dest.group.should equal(group)
    group.destinations.should include(dest)
  end

  it 'should destroy votes when destination is destroyed' do
    dest = destinations :valid_destination
    dest.voters << users(:three)
    dest.voters << users(:four)
    dest.group.members << users(:three)
    dest.group.members << users(:four)
    dest.save!
    vote_id_first = dest.votes[0].id
    vote_id_second = dest.votes[1].id
    dest.destroy
    expect{Vote.find vote_id_first}.to raise_error(ActiveRecord::RecordNotFound)
    expect{Vote.find vote_id_second}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should add event to choice' do
    dest = destinations :without_choice
    event = events :one
    dest.choice = event
    dest.save!
    dest.choice.should equal(event)
    event.destinations.size.should == 1
  end

  it 'should add place to choice' do
    dest = destinations :without_choice
    place = places :one
    dest.choice = place
    dest.save!
    dest.choice.should equal(place)
    place.destinations.should include(dest)
  end

  context 'validations' do
    it 'should not be possible to create a destination without a creator' do
      dest = destinations :without_creator
      expect{ dest.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a destination without a group' do
      dest = destinations :without_group
      expect{ dest.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a destination without a choice' do
      dest = destinations :without_choice
      expect{ dest.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a destination where creator is not a member or creator of the group' do
      dest = destinations :valid_destination
      dest.group.creator = users :two
      expect{ dest.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to create a destination where a voter is not a member or creator of the group' do
      dest = destinations :valid_destination
      dest.voters << users(:two)
      expect{ dest.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'should not be possible to allow creator to vote for his destination' do
      dest = destinations :valid_destination
      dest.voters << dest.creator
      expect{ dest.save! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
