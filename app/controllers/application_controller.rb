class ApplicationController < ActionController::API
  before_action :set_locale

  def set_locale
  I18n.locale = params[:locale] || I18n.default_locale
  end

  #Checks if current user is admin
  def admin?
    unless current_user and current_user.is_admin?
      error = "no access"
      render json: {message: error}, status: :unauthorized
    end
  end

  #Checks if current user verified their otp
  def verified?
    if current_user
      unless current_user and current_user.is_verified?
      error = "you need to verify your otp first"
      render json: {message: error}, status: :unauthorized
      end
    end
  end

  

end
