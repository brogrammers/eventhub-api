module EventhubApi
  module Middleware
    class LocationDetector

      attr_accessor :latitude, :longitude

      def initialize(application)
        @application = application
      end

      def call(environment)
        @environment = environment
        extract_location if location?
        inject_into_environment if valid_location?
        nested_application_call
      end

      def extract_location
        @latitude, @longitude = @location_header.split ':'
      end

      def location?
        @location_header = @environment['HTTP_X_LOCATION']
      end

      def inject_into_environment
        @environment['user.location'] = { latitude: @latitude, longitude: @longitude }
      end

      def valid_location?
        @latitude.to_f.to_s == @latitude.to_s and @longitude.to_f.to_s == @longitude.to_s
      end

      def nested_application_call
        @application.call @environment
      end

    end
  end
end