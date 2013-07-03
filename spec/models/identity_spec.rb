require 'spec_helper'

describe Identity do
  fixtures :identities, :core_users, :users, :business_users

  it 'should only assign provider facebook and eventhub' do
    identity = Identity.new
    identity.provider = :eventhub
    identity.save!
    identity.provider = :facebook
    identity.save!
    expect { identity.provider = :invalid_provider }.to raise_error(ArgumentError)
  end

end