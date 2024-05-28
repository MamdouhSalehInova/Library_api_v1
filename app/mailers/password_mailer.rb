class PasswordMailer < ApplicationMailer
  default from: "railstest22@gmail.com"
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.password_mailer.reset.subject
  #
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
