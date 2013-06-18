require 'spec_helper'

describe CoreUser do
  fixtures :core_users

  it 'should create a valid new core user record' do
    user = CoreUser.new
    user.name = 'Max'
    user.subtype = false
    user.save!.should be_true
  end

  it 'should not create a valid new core user record' do
    user = CoreUser.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

end