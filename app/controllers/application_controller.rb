class ApplicationController < ActionController::Base

  respond_to :json
  respond_to :xml

  protect_from_forgery
end
