module EventhubApi
  module Validator
    class Event < ActiveModel::Validator
      def validate(record)
        unless record.start_time != nil and record.start_time > Time.now
          record.errors[:start_time] << 'event start time must be in the future'
        end

        unless record.end_time != nil and record.start_time  and record.end_time > record.start_time
          record.errors[:end_time] << 'event must end after it starts'
        end

      end
    end
  end
end