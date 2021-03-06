require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'assertion_handler')

Doorkeeper.configure do
  orm :active_record

  resource_owner_authenticator do
    # TODO: Add authentication to Authorization Flow for 3rd Party Applications
    nil
  end

  resource_owner_from_assertion do
    client = Doorkeeper::OAuth::Client.find params[:client_id]
    scope = params[:scope]
    assertion = params[:assertion]
    type = params[:assertion_type]
    @handler ||= AssertionHandler.new type, assertion, client, scope
    @handler.assert
  end

  admin_authenticator do
    # TODO: Add authentication for admin users
  end

  authorization_code_expires_in 30.minutes
  access_token_expires_in 48.hours

  use_refresh_token

  # Provide support for an owner to be assigned to each registered application (disabled by default)
  # Optional parameter :confirmation => true (default false) if you want to enforce ownership of
  # a registered application
  # Note: you must also run the rails g doorkeeper:application_owner generator to provide the necessary support
  # enable_application_owner :confirmation => false

  # Define access token scopes for your provider
  # For more information go to https://github.com/applicake/doorkeeper/wiki/Using-Scopes
  default_scopes  :public
  optional_scopes :write, :update

  # Change the way client credentials are retrieved from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:client_id` and `:client_secret` params from the `params` object.
  # Check out the wiki for more information on customization
  client_credentials :from_params

  # Change the way access token is authenticated from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:access_token` or `:bearer_token` params from the `params` object.
  # Check out the wiki for mor information on customization
  access_token_methods :from_bearer_authorization

  # Change the test redirect uri for client apps
  # When clients register with the following redirect uri, they won't be redirected to any server and the authorization code will be displayed within the provider
  # The value can be any string. Use nil to disable this feature. When disabled, clients must provide a valid URL
  # (Similar behaviour: https://developers.google.com/accounts/docs/OAuth2InstalledApp#choosingredirecturi)
  #
  test_redirect_uri 'urn:ietf:wg:oauth:2.0:oob:eventhub-api'

  # Under some circumstances you might want to have applications auto-approved,
  # so that the user skips the authorization step.
  # For example if dealing with trusted a application.
  skip_authorization do |resource_owner, client|
    false
  end
end
