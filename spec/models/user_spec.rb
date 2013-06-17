require 'spec_helper'

describe User do

  before :all do
    @users = YAML.load_file File.join(File.dirname(__FILE__), '..', 'fixtures', 'users.yml')
  end

  it 'should not create a new invalid user record' do
    user = User.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should pass validation for a new invalid user record' do
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

  it 'should add a valid location to the user record' do
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

end