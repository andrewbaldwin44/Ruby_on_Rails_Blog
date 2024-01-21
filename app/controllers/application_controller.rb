class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  
    helper_method :signed_in?, :current_user
  
    private
  
    def signed_in?
      session[:user_id].present?
    end

    def current_user
        @current_user ||= User.find_by(id: session[:user_id])
    end

    def authenticate_user!
      redirect_to login_path unless signed_in?
    end
  end
  