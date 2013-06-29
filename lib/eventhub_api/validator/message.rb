module EventhubApi
  module Validator
    class Message < ActiveModel::Validator
      def validate(record)
        unless record.chatroom != nil and record.chatroom.group != nil and record.chatroom.group.members and record.chatroom.group.creator != nil
          record.errors[:user] << 'Invalid parent chatroom / group'
          return
        end

        unless record.chatroom.group.members.include? record.user or record.chatroom.group.creator == record.user
          record.errors[:user] << 'User does not belong to members or creator of the group of the chatroom of this message'
        end
      end
    end
  end
end