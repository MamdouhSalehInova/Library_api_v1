class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.accepted.subject
  #
  def accepted(user)
    @user = user
    mail to: @user.email, subject: "accepted"
  end

  def rejected(user)
    @user = user

    mail to: @user.email, subject: "rejected"
  end

  def returned(user)
    @user = user

    mail to: @user.email, subject: "Hope you enjoyed the book"
  end

  def otp_send(user)
    @user = user

    mail to: @user.email, subject: "Your one time password"
  end

  def reminder(user)
    @user = user

    mail to: @user.email, subject: "Reminder to return your book by tomorrow"
  end

  def late(user)
    @user = user
    mail to: @user.email, subject: "You are late"
  end
end
