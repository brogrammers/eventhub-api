require 'spec_helper'

describe CoreUser do
  fixtures :core_users, :users, :business_users, :devices

  it 'should not create a valid new core user record' do
    user = CoreUser.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should add a device to the user record' do
    user = users :one
    device = devices :one
    user.devices << device
    user.save!.should be_true
    device.save!.should be_true
    device.user(true).should be_a(User)
    user.devices(true).should include(device)
  end

  it 'should add a device to the business user record' do
    user = business_users :one
    device = devices :one
    user.devices << device
    user.save!.should be_true
    device.save!.should be_true
    device.user(true).should be_a(BusinessUser)
    user.devices(true).should include(device)
  end

  it 'should destroy all devices once the user is destroyed' do
    user = users :one
    device = devices :one
    user.devices << device
    user.save!.should be_true
    device.save!.should be_true
    user.destroy
    expect { Device.find device.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should destroy all devices once the business user is destroyed' do
    user = business_users :one
    device = devices :one
    user.devices << device
    user.save!.should be_true
    device.save!.should be_true
    user.destroy
    expect { Device.find device.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

end