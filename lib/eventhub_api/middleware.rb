module EventhubApi
  module Middleware
    autoload :LocationDetector, File.join(File.dirname(__FILE__), 'middleware', 'location_detector')
  end
end