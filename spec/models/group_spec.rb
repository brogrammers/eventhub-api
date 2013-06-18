require 'spec_helper'

describe Group do

  before :all do
    @groups = YAML.load_file File.join(File.dirname(__FILE__), '..', 'fixtures', 'groups.yml')
  end

  after :each do
    Group.destroy_all
    Destination.destroy_all
    User.destroy_all
    GroupMember.destroy_all
    PendingMember.destroy_all
  end

  it 'should create a new valid group object' do
    group = Group.new
    group.name = @groups['one']['name']
    group.description = @groups['one']['description']
    group.name.should eq(@groups['one']['name'])
    group.description.should eq(@groups['one']['description'])
    expect(group.save!).to be_true
  end

  it 'should attach a new destination' do
    destination = Destination.new
    group = Group.new
    group.destinations << destination
    group.destinations.size.should eq(1)
  end

  it 'should delete all destinations if group is deleted' do
    group = Group.new
    destination = Destination.new
    group.destinations << destination
    group.save!
    destination.save!
    group.destroy
    Destination.all.size.should eq(0)
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

