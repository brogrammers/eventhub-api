require 'spec_helper'

describe CoreUser do
  fixtures :core_users

  it 'should not create a valid new core user record' do
    user = CoreUser.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

end