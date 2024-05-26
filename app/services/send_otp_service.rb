class SendOtpService

  def initialize(user)
    @user = user
  end

  def send_otp
    UserMailer.otp_send(@user).deliver_now
  end

  def call
    send_otp
  end



end
