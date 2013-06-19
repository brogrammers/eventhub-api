require 'spec_helper'

describe Group do
  fixtures :groups, :destinations

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
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.invited << user
    group.save!
    user.save!
    group.invited.should include(user)
    user.groups_invited_to.should include(group)
  end

  it 'should be possible to remove user from invited' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.invited << user
    group.save!
    user.save!
    group.invited.delete user
    group.save!
    group.invited.should_not include(user)
    user.groups_invited_to.should_not include(group)
  end

  it 'invites should be removed when the group is removed' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.invited << user
    user.save!
    group.save!
    group.destroy
    PendingMember.all.size.should eq(0)
  end

  it 'should be possible to add user to members' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.members << user
    user.save!
    group.save!
    group.members.should include(user)
    user.groups_member_of.should include(group)
  end

  it 'should be possbile to remove user from mebers' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.members << user
    user.save!
    group.save!
    group.members.delete user
    group.save!
    group.members.should_not include(user)
    user.groups_member_of.should_not include(group)
  end

  it 'memberships should be removed when the group is removed' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.members << user
    user.save!
    group.save!
    group.destroy
    GroupMember.all.size.should eq(0)
  end

  it 'should be possible to assign user as a creator of a group' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.creator = user
    user.save!
    group.save!
    group.creator.should eq(user)
    user.groups_created.should include(group)
  end

  it 'should be possible to remove user from the creator of the group' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    group.creator = user
    user.save!
    group.save!
    group.creator = nil
    group.save!
    group.creator.should_not eq(user)
    user.groups_created.should_not include(group)
  end

end

