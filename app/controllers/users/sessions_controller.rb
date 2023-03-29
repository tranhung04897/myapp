# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    if current_user
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      old_url = after_sign_in_path_for(resource)
      redirect_to old_url and return if old_url != root_path

      redirect_to root_path
    else
      redirect_to new_user_session_path
    end
  end

  private
end
