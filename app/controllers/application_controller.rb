class ApplicationController < ActionController::Base
  layout :page_layout

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_current_user_to_js, if: :user_signed_in?

  protected

  def page_layout
    user_signed_in? ? 'cubbyhole' : 'application'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password, :plan_id) }
  end

  def after_sign_in_path_for(resource)
    if current_user.admin?
      admin_root_path
    else
      super
    end
  end

  def authenticate_admin!
    redirect_to root_path and return if user_signed_in? && !current_user.admin?
    authenticate_user!
  end

  def current_admin
    return nil if user_signed_in? && !current_user.admin?
    current_user
  end

  def set_current_user_to_js
    gon.current_user = UserSerializer.new(current_user).to_json
  end
end
