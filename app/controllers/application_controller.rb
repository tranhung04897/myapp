class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!

  add_flash_types :info, :error, :warning, :danger, :success
end
