class OtpController < ApplicationController
  include RackSessionsFix


  def verify
    @user = User.find_by(email: params[:otp][:email])
    @otp_attempt = params[:otp][:otp_attempt]
    if @otp_attempt ==  @user.otp_code
      @user.update(is_verified: true)
      sign_in(@user)
      @user.update(is_verified: true)
      render json: {
        status: {code: 200, message: 'Logged in sucessfully.'},
        data: UserSerializer.new(@user)
      }, status: :ok
    else
      render json: "Wrong OTP"
    end
  end

  def otp_params
    params.require(:otp).permit(:otp_attempt, :email)
  end
end
