require 'spec_helper'

describe Group do
  fixtures :core_users, :users, :groups, :destinations

  it 'should not create a valid new group record' do
    group = Group.new
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should add a new destination to a group' do
    destination = destinations :one
    group = groups :one
    group.destinations << destination
    group.save!
    group.destinations.size.should == 1
  end

  it 'should remove destination from a group' do
    destination = destinations :one
    group = groups :one
    group.destinations << destination
    group.save!
    group.destinations.delete destination
    group.save!
    group.destinations.size.should == 0
  end

  it 'should delete all destinations once a group is deleted' do
    group = groups :one
    destination = destinations :one
    group.destinations << destination
    group.save!
    destination.save!
    group.destroy
    expect { Destination.find destination.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should be possible to add user to invited' do
    user = users :one
    group = groups :one
    group.invited << user
    group.save!
    user.save!
    group.invited.should include(user)
    user.groups_invited_to.should include(group)
  end

  it 'should be possible to remove user from invited' do
    user = users :one
    group = groups :one
    group.invited << user
    group.save!
    user.save!
    group.invited.delete user
    group.save!
    group.invited.should_not include(user)
    user.groups_invited_to.should_not include(group)
  end

  it 'invites should be removed once the group is removed' do
    user = users :one
    group = groups :one
    group.invited << user
    user.save!
    group.save!
    group.destroy
    PendingMember.all.size.should eq(0)
  end

  it 'should be possible to add a user to members' do
    user = users :one
    group = groups :one
    group.members << user
    user.save!
    group.save!
    group.members.should include(user)
    user.groups_member_of.should include(group)
  end

  it 'should be possible to remove the user from members' do
    user = users :one
    group = groups :one
    group.members << user
    user.save!
    group.save!
    group.members.delete user
    group.save!
    group.members.should_not include(user)
    user.groups_member_of.should_not include(group)
  end

  it 'memberships should be removed once the group is removed' do
    user = users :one
    group = groups :one
    group.members << user
    user.save!
    group.save!
    group.destroy
    GroupMember.all.size.should == 0
  end

  it 'should be possible to assign user as a creator of a group' do
    user = users :one
    group = groups :one
    group.creator = user
    user.save!
    group.save!
    group.creator.should == user
    user.groups_created.should include(group)
  end
  it 'should not be possible to create a group with a name containing less than 5 charactes' do
    group = groups :one
    group.name = 'a'
    expect{ group.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group with a name containing more than 256 characters' do
    group = groups :one
    group.name = Array.new(257){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    expect{ group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group with a description contaning less than 5 characters' do
    group = groups :one
    group.description = 'ab'
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group with description containing more than 1024 characters' do
    group = groups :one
    group.description = Array.new(1025){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group without a creator' do
    group = groups :one
    group.creator = nil
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group with same user as a creator and member' do
    group = groups :one
    group.members << group.creator
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group with same user as a creator and invied' do
    group = groups :one
    group.invited << group.creator
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a group with same user as invited an member' do
    group = groups :one
    group.invited << (users :three)
    group.members << (users :three)
    expect { group.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end

