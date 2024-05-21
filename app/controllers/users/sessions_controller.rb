# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json


  def create
    @user = User.find_by(params[:email])
    self.resource = warden.authenticate!(auth_options)
    @user.update(otp_code: SecureRandom.rand(00000..99999))
    UserMailer.otp_send(@user).deliver_now
    render json: {message: "Otp Sent To #{@user.email}"}
  end

  def destroy
    @user = current_user
    @user.update(is_verified:false)
     super
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: {code: 200, message: 'Logged in sucessfully.'},
      data: UserSerializer.new(resource)
    }, status: :ok
  end

  def respond_to_on_destroy

    if current_user
      @user = current_user
      @user.update(is_verified: false)
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in


  # POST /resource/sign_in


  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
