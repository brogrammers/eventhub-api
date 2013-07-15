FactoryGirl.define do
  factory :group do
    name 'group name'
    description 'group description'
    creator do
      create(:user)
    end
  end

  factory :user do
    name 'Max Hoffman'
    registered true
    registered_at Time.now
    availability true
    identities do
      [create(:identity)]
    end
  end

  factory :identity do
    provider :facebook
    provider_id '1234567'
    token '7654321'
  end
end