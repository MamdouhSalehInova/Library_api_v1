class OtpController < ApplicationController
  include RackSessionsFix

  #Compares the user's assigned otp to his attempt by calling the verify otp service in app/services
  def verify
    @user = current_user
    @otp_attempt = params[:otp][:otp_attempt]
    if VerifyOtpService.new(@user, @otp_attempt).call
      render json: {
        status: {code: 200, message: 'Logged in sucessfully.'},
        data: UserSerializer.new(@user)
      }, status: :ok
    else
      render json: "Wrong OTP", status: 422
    end
  end

  def otp_params
    params.require(:otp).permit(:otp_attempt, :email)
  end
end
