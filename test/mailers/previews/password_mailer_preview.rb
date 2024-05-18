# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class PasswordMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/password_mailer/reset
  def reset
    PasswordMailer.reset
  end

  # Preview this email at http://localhost:3000/rails/mailers/password_mailer/changed
  def changed
    PasswordMailer.changed
  end

end
