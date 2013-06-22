require 'spec_helper'

describe Message do
  fixtures :users, :messages, :chatrooms, :groups

  it 'should not be possible to create invalid message' do
    message = Message.new
    expect{ message.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should be possible to create message with chatroom, user and content' do
    message = Message.new
    message.content = 'content'
    chatroom = chatrooms :two
    message.chatroom = chatroom
    user = users :one
    message.user = user
    chatroom.group.creator = user
    chatroom.save!
    message.save!
    message.content.should == 'content'
    message.chatroom.should == chatroom
    message.user.should == user
  end

  it 'should not be possible to create a message with empty string' do
    message = Message.new
    message.content = ''
    chatroom = chatrooms :two
    message.chatroom = chatroom
    user = users :one
    message.user = user
    chatroom.save!
    expect{ message.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a message with string containing more than 10000 characters' do
    message = Message.new
    message.content = Array.new(10001){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
    chatroom = chatrooms :two
    message.chatroom = chatroom
    user = users :one
    message.user = user
    chatroom.group.creator = user
    chatroom.save!
    expect{ message.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not be possible to create a message with a user that is not a member or creator of chatrooms group' do
    message = Message.new
    message.content = 'content'
    chatroom = chatrooms :two
    message.chatroom = chatroom
    user = users :four
    message.user = user
    chatroom.save!
    expect{ message.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end