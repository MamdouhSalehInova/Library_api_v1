class AdminMailer < ApplicationMailer
  def new_order(admin)
    @admin = admin
    mail to: @admin.email, subject: "New Order"
  end

  def late_order(admin)
    @admin = admin
    mail to: @admin.email, subject: "Users are late returning their books"
  end
end
