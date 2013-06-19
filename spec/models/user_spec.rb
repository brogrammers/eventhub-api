require 'spec_helper'

describe User do
  fixtures :users, :core_users

  LATITUDE  = 53.344103999999990000
  LONGITUDE = -6.267493699999932000

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
    user.location = Location.create :latitude => LATITUDE, :longitude => LONGITUDE
    user.save!
    user.location.latitude.should == LATITUDE
    user.location.longitude.should == LONGITUDE
  end

  #USER -> GROUP MEMBERSHIP

  it 'should be possible to add group (as membership) to the user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups_member_of << group
    group.save!
    user.save!
    user.groups_member_of.should include(group)
    group.members.should include(user)
  end

  #USER -> GROUP MEMBERSHIP -> TRACKING

  it 'should be possible to remove group (as membership) from the user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups_member_of << group
    group.save!
    user.save!
    user.groups_member_of.delete group
    user.save!
    user.groups_member_of.should_not include(group)
    group.members.should_not include(user)
  end

  it 'should be possible to set user as trackable for the group' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
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
    group_membership.trackable.should eq(true)
  end

  it 'should be possible to set user as utrackable for the group' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
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
    group_membership.trackable.should eq(false)
  end

  it 'should destroy all memberships when the user is destroyed' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group1 = Group.new
    group2 = Group.new
    user.groups_member_of << group1
    user.groups_member_of << group2
    user.save!
    group1.save!
    group2.save!
    user.destroy
    GroupMember.all.size.should eq(0)
    group1.members.size.should eq(0)
    group2.members.size.should eq(0)
  end

  #USER -> GROUP INVITATIONS

  it 'should be possible to add invitation to user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups_invited_to << group
    group.save!
    user.save!
    user.groups_invited_to.should include(group)
    group.invited.should include(user)
  end

  it 'should be possible to remove invitation from user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups_invited_to << group
    group.save!
    user.save!
    user.groups_invited_to.delete group
    user.save!
    user.groups_invited_to.should_not include(group)
    group.invited.should_not include(user)
  end

  it 'should remove all invitations when the user is destroyed' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group1 = Group.new
    group2 = Group.new
    user.groups_invited_to << group1
    user.groups_invited_to << group2
    user.save!
    group1.save!
    group2.save!
    user.destroy
    PendingMember.all.size.should eq(0)
    group1.invited.size.should eq(0)
    group2.invited.size.should eq(0)
  end

  #USER - GROUP POSSESION

  it 'should be possible to add group to the user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group1 = Group.new
    user.groups_created << group1
    user.save!
    group1.save!
    user.groups_created.should include(group1)
    group1.creator.should eq(user)
  end

  it 'should be possible to remove group from the user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group1 = Group.new
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
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group1 = Group.new
    user.groups_created << group1
    user.save!
    group1.save!
    user.destroy
    Group.all.size.should eq(0)
  end

  it 'should be possible to add location post to user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    post = LocationPost.new
    user.location_posts << post
    user.save!
    post.save!
    user.location_posts.should include(post)
    post.user.should eq(user)
  end

  it 'should be possible to remove location post from user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    post = LocationPost.new
    user.location_posts << post
    user.save!
    post.save!
    user.location_posts.delete post
    user.save!
    post.save!
    user.location_posts.should_not include(post)
    #TODO: fix -> post.user.should_not eq(user)
  end

  it 'should destroy all posts when user is destroyed' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    post = LocationPost.new
    user.location_posts << post
    user.save!
    post.save!
    user.destroy
    LocationPost.all.size.should eq(0)
  end

end