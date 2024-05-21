require 'sidekiq-scheduler'
class LateNotifierJob
  include Sidekiq::Job
  queue_as :default

  def perform
    @orders = Order.all
    @late_orders = @orders.where(return_date: Date.current - 1)
    @late_orders.update(status: 5)
    @admins = User.where(admin: true)

      if @late_orders.present?
        @late_orders.each do |order|
          UserMailer.late(order.user).deliver_later
        end
        @admins.each do |admin|
          AdminMailer.late_order(admin).deliver_later
        end
      end
  end

end
