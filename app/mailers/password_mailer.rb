class PasswordMailer < ApplicationMailer

  def reset(user)
    @user = user
    @token = user.reset_password_token
    mail to: @user.email, subject: "Reset your password"
  end

  def changed(user)
    @user = user
    mail to: @user.email, subject: "Password changed"
  end

end
