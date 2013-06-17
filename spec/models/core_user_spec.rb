require 'spec_helper'

describe CoreUser do

  before :all do
    @users = YAML.load_file File.join(File.dirname(__FILE__), '..', 'fixtures', 'core_users.yml')
  end

  after :all do
    CoreUser.destroy_all
  end

  it 'should create a valid new core user record' do
    user = CoreUser.new
    user.name = @users['one']['name']
    user.subtype = true
    expect(user.save!).to be_true
  end

  it 'should not create a valid new core user record' do
    user = CoreUser.new
    expect{user.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

end