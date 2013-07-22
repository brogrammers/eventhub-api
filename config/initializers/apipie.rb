Apipie.configure do |config|
  config.app_name                = "Eventhub-Api"
  config.copyright               = "&copy; #{Time.now.year} Eventhub"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/docs"
  config.validate                = false
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
  config.app_info                = "Eventhub REST API documentation."
end
