module EventhubApi
  module Validator
    class Destination < ActiveModel::Validator
      def validate(record)
        unless record.creator == record.group.creator or record.group.members.include? record.creator
          record.errors[:creator] << I18n.translate!('activerecord.errors.models.destination.attributes.creator.member_or_creator')
        end

        record.voters.each do |voter|
          unless record.group.creator == voter or record.group.members.include? voter
            record.errors[:voters] << I18n.translate!('activerecord.errors.models.destination.attributes.voters.member_or_creator')
          end
        end

        if record.voters.include? record.creator
          record.errors[:creator] << I18n.translate!('activerecord.errors.models.destination.attributes.creator.cant_vote')
        end
      end
    end
  end
end