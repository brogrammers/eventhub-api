require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'eventhub_api')

class ApplicationController < ActionController::Base
  before_filter :find_current_user

  respond_to :json, :xml

  protect_from_forgery

  protected

  def find_current_user
    @current_user ||= User.find doorkeeper_token.resource_owner_id
  end
end
