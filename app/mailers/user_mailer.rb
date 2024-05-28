class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.accepted.subject
  #
  def accepted(user, book)
    @user = user
    @book = book
    mail to: @user.email, subject: "accepted"
  end

  def rejected(user, book)
    @user = user
    @book = book
    mail to: @user.email, subject: "rejected"
  end

  def returned(user, book)
    @user = user
    @book = book
    mail to: @user.email, subject: "Returned Book"
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
