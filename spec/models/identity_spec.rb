require 'spec_helper'

describe Identity do
  fixtures :identities, :core_users, :users, :business_users

  it 'should not save an invalid identity record' do
    identity = Identity.new
    expect { identity.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should only assign provider facebook and eventhub' do
    identity = identities :one
    identity.provider = :eventhub
    identity.save!
    identity.provider = :facebook
    identity.save!
    expect { identity.provider = :invalid_provider }.to raise_error(ArgumentError)
  end

end