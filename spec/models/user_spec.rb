require 'spec_helper'

describe User do

  before :all do
    @users = YAML.load_file File.join(File.dirname(__FILE__), '..', 'fixtures', 'users.yml')
  end

  after :all do
    User.destroy_all
    Group.destroy_all
  end

  it 'should not create a new invalid user record' do
    user = User.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not pass validation for a new invalid user record' do
    user = User.new
    expect(user.valid?).to be_false
    expect(user.errors.full_messages.size).to eq(4)
  end

  it 'should create a new valid user record' do
    user = User.new
    user.name = @users['one']['name']
    user.availability = @users['one']['availability']
    user.registered = @users['one']['registered']
    user.registered_at = Time.now
    expect(user.save!).to be_true
  end

  it 'should add a valid location to a user record' do
    user = User.new
    user.name = @users['one']['name']
    user.availability = @users['one']['availability']
    user.registered = @users['one']['registered']
    user.registered_at = Time.now
    user.location = Location.new
    user.location.latitude = @users['one']['location']['latitude']
    user.location.longitude = @users['one']['location']['longitude']
    user.save!
    expect(user.location.latitude).to eq(@users['one']['location']['latitude'])
    expect(user.location.longitude).to eq(@users['one']['location']['longitude'])
  end

  it 'should be possible to add group to the user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups << group
    group.save!
    user.save!
    user.groups.should include(group)
    group.members.should include(user)
  end

  it 'should be possible to remove group from the user' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups << group
    group.save!
    user.save!
    user.groups.delete group
    user.save!
    user.groups.should_not include(group)
    group.members.should_not include(user)
  end

  it 'should be possible to set user as trackable for the group' do
    user = User.new :name => 'Max', :availability => true, :registered => true, :registered_at => Time.now
    group = Group.new
    user.groups << group
    group_membership = nil
    user.save!
    group.save!
    user.group_memberships.each do |membership|
      next if membership.group != group
      membership.trackable = true
      group_membership = membership
    end
    group_membership.save!
    group_membership.trackable.should eq(false)
  end

  it 'should be possible to set user as utrackable for the group' do

  end

  it 'should destroy all memberships when the user is destroyed' do

  end

end