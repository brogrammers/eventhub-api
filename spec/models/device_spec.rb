require 'spec_helper'

describe Device do
  fixtures :devices, :core_users, :users

  it 'should not save an invalid device model' do
    device = Device.new
    expect { device.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

end