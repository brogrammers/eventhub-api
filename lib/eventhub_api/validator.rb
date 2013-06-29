module EventhubApi
  module Validator
    autoload :Event, File.join(File.dirname(__FILE__), 'validator', 'event')
    autoload :Identity, File.join(File.dirname(__FILE__), 'validator', 'identity')
    autoload :Group, File.join(File.dirname(__FILE__), 'validator', 'group')
    autoload :Message, File.join(File.dirname(__FILE__), 'validator', 'message')
  end
end