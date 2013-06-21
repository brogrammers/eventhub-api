require 'spec_helper'

describe Chatroom do
  fixtures :groups, :comments, :chatrooms, :users

  it 'should be possible to add group to the chatroom' do
    chatroom = chatrooms :one
    group = groups :three
    chatroom.group = group
    chatroom.save!
    group.save!
    chatroom.group.should == group
    group.chatroom.should == chatroom
  end

  it 'should destroy all messages if chatroom is destroyed' do

  end

  it 'should not be possible to create a chatroom without a group' do
    chatroom = chatrooms :one
    expect{ chatroom.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end