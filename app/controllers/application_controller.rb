class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  protect_from_forgery
  skip_before_action :verify_authenticity_token

  add_flash_types :success, :warning, :danger, :info
  
end
