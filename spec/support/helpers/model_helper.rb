module ModelHelper

  def create_oauth_application
    @application = Doorkeeper::Application.create! :name => 'test', :redirect_uri => 'urn:ietf:wg:oauth:2.0:oob:eventhub-api'
  end

end

RSpec.configuration.send :include, ModelHelper, :type => :request