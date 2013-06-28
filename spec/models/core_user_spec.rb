require 'spec_helper'

describe CoreUser do
  fixtures :core_users, :users, :identities, :business_users

  it 'should not create a invalid new core user record' do
    user = CoreUser.new
    expect { user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

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