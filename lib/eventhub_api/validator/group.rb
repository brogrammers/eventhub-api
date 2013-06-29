module EventhubApi
  module Validator
    class Group < ActiveModel::Validator
      def validate(record)
        all_users = record.members + record.invited << record.creator
        unless all_users.length == all_users.uniq.length
          record.errors[:members] << 'Single user can only belong to creator or members or invited'
          record.errors[:invited] << 'Single user can only belong to creator or members or invited'
          record.errors[:creator] << 'Single user can only belong to creator or members or invited'
        end
      end
    end
  end
end