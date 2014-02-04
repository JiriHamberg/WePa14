class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_user_admin?

  def current_user
  	return nil if session[:user_id].nil?
  	User.find(session[:user_id])
  end

  def current_user_admin?
    current_user && current_user.admin
  end

  def invalidate_session
    session[:user_id] = nil
    redirect_to :root
  end

  def ensure_that_signed_in 
    redirect_to signin_path, notice:'you should be signed in' if current_user.nil?
  end

  def ensure_that_is_admin
    redirect_to :back unless current_user_admin?
  end
end
