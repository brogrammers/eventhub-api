Apipie.configure do |config|
  config.app_name                = "Eventhub-Api"
  config.copyright               = "&copy; #{Time.now.year} Eventhub"
  config.default_version         = "v1"
  config.api_base_url            = "/api"
  config.doc_base_url            = "/docs"
  config.validate                = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.app_info                = "Eventhub REST API documentation."
end
