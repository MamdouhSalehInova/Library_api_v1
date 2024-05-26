class VerifyOtpService

  def initialize(user, otp_attempt)
    @user = user
    @otp_attempt = otp_attempt
  end

  def verify_otp
    if @otp_attempt ==  @user.otp_code
      @user.update(is_verified: true)
      @user.update(is_verified: true)
    else
     return false
    end
  end

  def call
    verify_otp
  end



end
