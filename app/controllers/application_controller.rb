class ApplicationController < ActionController::API


  def admin?
    unless current_user and current_user.is_admin?
      error = "no access"
      render json: error
    end
  end

  def verified?
    if current_user
      unless current_user and current_user.is_verified?
      error = "you need to verify your otp first"
      render json: error
    end
  end
  end

end
