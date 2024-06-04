require 'sidekiq-scheduler'

class ReminderJob
  include Sidekiq::Job
queue_as :default

  def perform
      @tomorrow_orders = Order.where(return_date: Date.current + 1)

      #Remindes users to return their book tomorrow
      @tomorrow_orders.each do |order|
      UserMailer.reminder(order.user).deliver_later
      end
      
  end

end
