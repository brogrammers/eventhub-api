module EventhubApi
  autoload :Validator, File.join(File.dirname(__FILE__), 'eventhub_api', 'validator')
  autoload :Middleware, File.join(File.dirname(__FILE__), 'eventhub_api', 'middleware')
end