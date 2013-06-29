require 'spec_helper'

describe User do
  fixtures :users, :core_users, :business_users, :groups, :location_posts, :locations, :chatrooms, :identities, :places

  it 'should not create a new invalid user record' do
    user = User.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not pass validation for a new invalid user record' do
    user = User.new
    user.valid?.should be_false
  end

  it 'should add a valid location to a user record' do
    user = users(:one)
    user.location = locations :one
    user.save!
    user.location.should == locations(:one)
  end

  context 'USER -> GROUP MEMBERSHIP' do

    it 'should be possible to add group (as membership) to the user' do
      user = users :one
      group = groups :one
      user.groups_member_of << group
      group.save!
      user.save!
      user.groups_member_of.should include(group)
      group.members.should include(user)
    end

  end

  context 'USER -> GROUP MEMBERSHIP -> TRACKING' do

    it 'should be possible to remove group (as membership) from the user' do
      user = users :one
      group = groups :one
      user.groups_member_of << group
      group.save!
      user.save!
      user.groups_member_of.delete group
      user.save!
      user.groups_member_of.should_not include(group)
      group.members(true).should_not include(user)
    end

  end

  it 'should be possible to set user as trackable for the group' do
    user = users :one
    group = groups :one
    user.groups_member_of << group
    group_membership = nil
    user.save!
    group.save!
    user.group_memberships.each do |membership|
      next if membership.group != group
      membership.trackable = true
      group_membership = membership
    end
    group_membership.save!
    group_membership.trackable.should be_true
  end

  it 'should be possible to set user as untrackable for the group' do
    user = users :one
    group = groups :one
    user.groups_member_of << group
    group_membership = nil
    user.save!
    group.save!
    user.group_memberships.each do |membership|
      next if membership.group != group
      membership.trackable = true
      group_membership = membership
    end
    group_membership.save!
    group_membership.trackable = false
    group_membership.save!
    group_membership.trackable.should be_false
  end

  it 'should destroy all memberships when the user is destroyed' do
    user = users :one
    group1 = groups :one
    group2 = groups :two
    user.groups_member_of << group1
    user.groups_member_of << group2
    user.save!
    group1.save!
    group2.save!
    user.destroy
    GroupMember.all.size.should == 0
    group1.members(true).size.should == 0
    group2.members(true).size.should == 0
  end

  context 'USER -> GROUP INVITATIONS' do

    it 'should be possible to add invitation to user' do
      user = users :one
      group = groups :one
      user.groups_invited_to << group
      group.save!
      user.save!
      user.groups_invited_to.should include(group)
      group.invited.should include(user)
    end

  end

  it 'should be possible to remove invitation from user' do
    user = users :one
    group = groups :one
    user.groups_invited_to << group
    group.save!
    user.save!
    user.groups_invited_to.delete group
    user.save!
    user.groups_invited_to.should_not include(group)
    group.invited(true).should_not include(user)
  end

  it 'should remove all invitations once the user is destroyed' do
    user = users :one
    group1 = groups :one
    group2 = groups :two
    user.groups_invited_to << group1
    user.groups_invited_to << group2
    user.save!
    group1.save!
    group2.save!
    user.destroy
    PendingMember.all.size.should == 0
    group1.invited(true).size.should == 0
    group2.invited(true).size.should == 0
  end

  context 'USER - GROUP POSSESSION' do

    it 'should be possible to add group to the user' do
      user = users :one
      group1 = groups :one
      user.groups_created << group1
      user.save!
      group1.save!
      user.groups_created.should include(group1)
      group1.creator.should == user
    end

  end

  it 'should be possible to remove group from the user' do
    user = users :one
    group1 = groups :one
    user.groups_created << group1
    user.save!
    group1.save!
    user.groups_created.delete group1
    user.save!
    group1.save!
    user.groups_created.should_not include(group1)
    #TODO: FIX!! -> group1.creator.should_not eq(user)
  end

  it 'should remove all groups of that user if the user is destroyed' do
    user = users :one
    group1 = groups :one
    user.groups_created << group1
    user.save!
    group1.save!
    user.destroy
    expect { Group.find group1.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should be possible to add location post to user' do
    user = users :one
    post = LocationPost.new
    user.location_posts << post
    user.save!
    post.save!
    user.location_posts.should include(post)
    post.user.should == user
  end

  it 'should be possible to remove location post from user' do
    user = users :one
    post = location_posts :one
    user.location_posts << post
    user.save!
    post.save!
    user.location_posts.delete post
    user.save!
    post.save!
    user.location_posts.should_not include(post)
    #TODO: fix -> post.user.should_not eq(user)
  end

  it 'should destroy all location posts once the user is destroyed' do
    user = users :one
    post = location_posts :one
    user.location_posts << post
    user.save!
    post.save!
    user.destroy
    LocationPost.all.size.should == 0
  end

  it 'should be possible to add place to a business user' do
    user = business_users :one
    place = places :one
    user.places << place
    user.save!
    place.save!
    user.places(true).should include(place)
    place.creator(true).should == user
  end

  it 'should be possible to add place to user' do
    user = users :one
    place = places :one
    user.places << place
    user.save!
    place.save!
    user.places(true).should include(place)
    place.creator(true).should == user
  end

  it 'should remove all places of the user when the user is destroyed' do

  end
end