class SendOtpService

  def initialize(user)
    @user = user
  end

  def send_otp
    UserMailer.otp_send(@user).deliver_later
  end

  def call
    send_otp
  end



end
