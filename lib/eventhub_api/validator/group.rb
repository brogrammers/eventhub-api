module EventhubApi
  module Validator
    class Group < ActiveModel::Validator
      def validate(record)
        all_users = record.members + record.invited << record.creator
        unless all_users.length == all_users.uniq.length
          record.errors[:user] << I18n.translate!('activerecord.errors.models.group.attributes.user.single_user')
        end
      end
    end
  end
end