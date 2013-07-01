module EventhubApi
  module Validator
    class Event < ActiveModel::Validator
      def validate(record)
        unless record.start_time != nil and record.start_time > Time.now
          record.errors[:start_time] << I18n.translate!('activerecord.errors.models.event.attributes.start_time.in_future')
        end

        unless record.end_time != nil and record.start_time  and record.end_time > record.start_time
          record.errors[:end_time] << I18n.translate!('activerecord.errors.models.event.attributes.end_time.after_start_time')
        end

      end
    end
  end
end