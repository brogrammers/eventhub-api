module EventhubApi
  module Validator
    class CoreUser < ActiveModel::Validator
      def validate(record)
        record.errors[:user] << I18n.translate!('activerecord.errors.models.core_user.attributes.user.one_identity') if record.identities.size < 1
      end
    end
  end
end