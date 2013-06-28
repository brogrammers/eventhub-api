require 'spec_helper'

describe CoreUser do
  fixtures :core_users, :users, :identities, :business_users, :devices, :notifications

  it 'should not create an invalid new core user record' do
    user = CoreUser.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  context 'devices' do

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

  context 'notifications' do

    it 'should add a notification to the user record' do
      user = users :one
      notification = notifications :one
      user.notifications << notification
      user.save!.should be_true
      notification.save!.should be_true
      notification.user(true).should be_a(User)
      user.notifications(true).should include(notification)
    end

    it 'should add a notification to the business user record' do
      user = business_users :one
      notification = notifications :one
      user.notifications << notification
      user.save!.should be_true
      notification.save!.should be_true
      notification.user(true).should be_a(BusinessUser)
      user.notifications(true).should include(notification)
    end

    it 'should destroy all notifications once the user is destroyed' do
      user = users :one
      notification = notifications :one
      user.notifications << notification
      user.save!.should be_true
      notification.save!.should be_true
      user.destroy
      expect { Notification.find notification.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should destroy all notifications once the business user is destroyed' do
      user = business_users :one
      notification = notifications :one
      user.notifications << notification
      user.save!.should be_true
      notification.save!.should be_true
      user.destroy
      expect { Notification.find notification.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

  context 'identities' do

    it 'should add an identity to the user record' do
      user = users :one
      identity = identities :one
      user.identities << identity
      user.save!
      identity.save!
      identity.user.should be_a(User)
      user.identities(true).should include(identity)
    end

    it 'should add an identity to the business user record' do
      user = business_users :one
      identity = identities :one
      user.identities << identity
      user.save!
      identity.save!
      identity.user(true).should be_a(BusinessUser)
      identity.user(true).name.should == user.name
      user.identities(true).should include(identity)
    end

    it 'should destroy all identities once the user is destroyed' do
      user = users :one
      identity = identities :one
      user.identities << identity
      identity.save!
      user.save!
      user.destroy
      expect { Identity.find identity.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should destroy all identities once the business user is destroyed' do
      user = business_users :one
      identity = identities :one
      user.identities << identity
      identity.save!
      user.save!
      user.destroy
      expect { Identity.find identity.id }.to raise_error(ActiveRecord::RecordNotFound)
    end

  end

end