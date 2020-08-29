class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :require_login

  def login!(user)
    @current_user = user
    session[:session_token] = user.session_token
  end

  def current_user
    return nil if session[:session_token].nil?
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  private

  def require_login
    unless current_user
      flash[:alert] = "You must be logged in to view this resource."
      redirect_to new_session_url
    end
  end
end
