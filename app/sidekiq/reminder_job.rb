
require 'sidekiq-scheduler'

class ReminderJob
  include Sidekiq::Job
queue_as :default
  def perform
      @orders = Order.all
      @tomorrow_orders = @orders.where(return_date: Date.current + 1)
      @tomorrow_orders.each do |order|
      UserMailer.reminder(order.user).deliver_later
      end
  end
end
