class ApplicationController < ActionController::API
  before_action :set_locale
  before_action :process_token

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

  private

  # Check for auth headers - if present, decode or send unauthorized response (called always to allow current_user)
  def process_token
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.secrets.secret_key_base).first
        @current_user_id = jwt_payload['id']
      rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
        render json: {message: "you need to login first "}
      end
    end
  end

  # If user has not signed in, return unauthorized response (called only when auth is needed)
  def authenticate_user!(options = {})
    render json: {message: "You need to sign in or sign up before continuing."} unless signed_in?
  end

  # set Devise's current_user using decoded JWT instead of session
  

  # check that authenticate_user has successfully returned @current_user_id (user is authenticated)
  def signed_in?
    @current_user_id.present?
  end


  

end
