class ApplicationController < ActionController::Base
  before_filter :find_current_user

  respond_to :json, :xml

  rescue_from ActiveRecord::RecordInvalid do |exception|
    @object = exception.record
    render status: 400, template: 'api/v1/errors/record_invalid'
  end

  rescue_from ActiveRecord::RecordNotFound do
    @object = Object.new
    render status: 404, template: 'api/v1/errors/record_not_found'
  end

  rescue_from ActiveRecord::NotPrivilegedError do
    @object = Object.new
    render status: 403, template: 'api/v1/errors/not_privileged_error'
  end

  protected

  def find_current_user
    @current_user ||= User.find doorkeeper_token.resource_owner_id if doorkeeper_token
  end
end
