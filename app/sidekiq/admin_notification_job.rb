class AdminNotificationJob < ApplicationJob

    queue_as :default
  
    def perform
      admins = User.where(is_admin: true)
      admins.each do |admin|
        AdminMailer.new_order(admin).deliver_later
      end
    end
  end