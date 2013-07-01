module EventhubApi
  module Validator
    class Location < ActiveModel::Validator
      def validate(record)
        record.errors['city'] << "can't be blank" if record.city.nil?
        record.errors['country'] << "can't be blank" if record.country.nil?
      end
    end
  end
end