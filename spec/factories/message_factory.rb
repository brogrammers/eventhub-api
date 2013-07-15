FactoryGirl.define do

  factory :message do
    content 'my message'

    chatroom do
      create(:chatroom)
    end

    user do |message|
      message.chatroom.group.creator
    end

  end

  factory :chatroom do
    group do
      create(:group)
    end
  end

end