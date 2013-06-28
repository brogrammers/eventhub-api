module UrlHelper

  def assertion_endpoint_url(params = { })
    parameters = {
      :client_id      => params[:client_id]       || params[:client] ? params[:client].uid : nil,
      :client_secret  => params[:client_secret]   || params[:client] ? params[:client].secret : nil,
      :redirect_to    => params[:redirect_uri]    || params[:client] ? params[:client].redirect_uri : nil,
      :grant_type     => params[:grant_type]      || 'assertion',
      :assertion_type => params[:assertion_type],
      :assertion      => params[:assertion]
    }
    "#{build_query(parameters)}"
  end

  def build_query(hash)
    Rack::Utils.build_query(hash)
  end

end

RSpec.configuration.send :include, UrlHelper, :type => :request