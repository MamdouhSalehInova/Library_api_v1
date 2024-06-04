require 'sidekiq-scheduler'
class LateNotifierJob
  include Sidekiq::Job
  queue_as :default

  def perform

    @late_orders = Order.where(return_date: Date.current - 1, status: 1)
    @late_orders.update_all(status: 4)
    @admins = User.where(is_admin: true)

      if Order.where(status: 4).present?

        #Notifies Users that they are late
        Order.where(status: 4).each do |order|
          UserMailer.late(order.user).deliver_later
        end

        #Notifies admins that users are late
        @admins.each do |admin|
          AdminMailer.late_order(admin).deliver_later
        end

      end
  end

end
