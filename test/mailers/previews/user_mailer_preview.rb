# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/accepted
  def accepted
    UserMailer.accepted
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/rejected
  def rejected
    UserMailer.rejected
  end

end
