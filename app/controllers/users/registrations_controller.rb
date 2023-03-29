# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :require_no_authentication, only: :cancel
  before_action :authorize_update_user, only: [:edit, :update]
  before_action :authorize_create_user, only: [:new, :create]
  before_action :configure_sign_up_params, only: :create
  before_action :configure_account_update_params, only: :update
  before_action :load_user, only: [:edit, :update]
  before_action :load_checkbox_roles
  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
  end

  def edit
    super
  end

  def update
    resource.current_user = current_user
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = if params[:user][:password].blank?
      update_resource_without_password(resource, account_update_params)
    else
      update_resource(resource, account_update_params)
    end

    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in current_user, scope: resource_name if sign_in_after_change_password?
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, danger: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  protected

  def authorize_create_user
    authorize! :manage, User
  end

  def authorize_update_user
    authorize! :update, User
  end

  def load_checkbox_roles
    roles = Role.all
    if current_user.is_admin?
      @select_roles = roles.map { |role| [role.name.capitalize, role.id] }.compact
    else
      @select_roles = roles.map { |role| [role.name.capitalize, role.id] unless role.id == 1 }.compact
    end
  end

  def load_user
    self.resource = resource_class.to_adapter.get!(params[:id])
  end

  def current_user_is_admin?
    user_signed_in? && current_user.is_admin?
  end

  def signed_in_root_path(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    router_name = Devise.mappings[scope].router_name

    home_path = "#{scope}_root_path"

    context = router_name ? send(router_name) : self

    if context.respond_to?(home_path, true)
      context.send(home_path)
    elsif context.respond_to?(:root_path)
      users_path
    elsif respond_to?(:root_path)
      users_path
    else
      '/'
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    attributes = [:username, :name, :email, :role_id, :password, :password_confirmation]

    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
  end

  def sign_up(resource_name, resource)
    sign_in(resource_name, resource) unless current_user_is_admin?
  end

  def after_sign_up_path_for(_resource)
    users_url
  end

  def configure_account_update_params
    attributes = [:username, :name, :email, :role_id, :password, :password_confirmation]
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def update_resource_without_password(resource, params)
    resource.update_without_password(params)
  end

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end
