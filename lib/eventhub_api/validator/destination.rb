module EventhubApi
  module Validator
    class Destination < ActiveModel::Validator
      def validate(record)
        unless record.creator == record.group.creator or record.group.members.include? record.creator
          record.errors[:creator] << 'of destination must be either a creator or member of group of this destination'
        end

        record.voters.each do |voter|
          unless record.group.creator == voter or record.group.members.include? voter
            record.errors[:voters] << 'must be a creator or member of group of this destination'
          end
        end
      end
    end
  end
end