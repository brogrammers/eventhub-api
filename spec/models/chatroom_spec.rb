require 'spec_helper'

describe Chatroom do
  fixtures :groups, :comments, :chatrooms, :users, :messages

  it 'should be possible to add group to the chatroom' do
    chatroom = chatrooms :one
    group = groups :three
    chatroom.group = group
    chatroom.save!
    group.save!
    chatroom.group.should == group
    group.chatroom.should == chatroom
  end

  it 'should be possible to add message to chatroom' do
    message = messages :one
    chatroom = chatrooms :two
    chatroom.messages << message
    message.save!
    chatroom.save!
    chatroom.messages.should include(message)
    message.chatroom.should == chatroom
  end

  it 'should destroy all messages if chatroom is destroyed' do
    message = messages :one
    chatroom = chatrooms :two
    chatroom.messages << message
    message.save!
    chatroom.save!
    chatroom.destroy
    expect { Message.find message.id }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'should not be possible to create a chatroom without a group' do
    chatroom = chatrooms :one
    expect{ chatroom.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end