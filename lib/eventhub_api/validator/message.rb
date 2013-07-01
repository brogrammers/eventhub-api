module EventhubApi
  module Validator
    class Message < ActiveModel::Validator
      def validate(record)
        unless record.chatroom.group.members.include? record.user or record.chatroom.group.creator == record.user
          record.errors[:user] << I18n.translate!('activerecord.errors.models.message.attributes.user.not_member')
        end
      end
    end
  end
end