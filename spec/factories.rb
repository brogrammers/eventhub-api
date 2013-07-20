FactoryGirl.define do

  factory :message do
    content 'message content'

    after(:build) { |message|
      group = create(:group)
      message.user = group.creator
      message.chatroom = group.chatroom
    }

  end

  factory :chatroom do |chatroom|
    chatroom.association :group, factory: :group
  end

  factory :group do |group|
    name 'group name'
    description 'group description'
    group.association :creator, factory: :user
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