module EventhubApi
  module Validator
    class CoreUser < ActiveModel::Validator
      def validate(record)
        record.errors[:identities] << 'Needs at least one identity' if record.identities.size < 1
      end
    end
  end
end