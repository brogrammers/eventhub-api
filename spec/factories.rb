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

    factory :group_with_members_and_invited do
      after(:build) do |group|
        group.invited = create_list(:user, 1)
        group.members = create_list(:user, 3)
      end
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