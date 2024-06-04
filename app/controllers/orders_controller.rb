class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: [:my_orders, :create, :update, :index, :show, :late]
  before_action :admin?, only: [ :index ,:accept, :reject, :return, :late, :destroy, :update, :show]
  before_action :verified?

  def index
    @orders = Order.page(params[:page]).per(params[:page_size]).order(:id)
    render json: @orders
  end

  #Renders all orders with status "late"
  def late
    @orders = Order.all
    @late_orders = @orders.where(status: 4)
    render json: @late_orders
  end

  #Renders all current user orders
  def my_orders
    @orders = current_user.orders.page(params[:page]).per(params[:page_size]).order(:id)
    render json: @orders.order(:id), each_serializer: OrderSerializer
  end

  #Updates order's status to "accepted"
  def accept
    @order = Order.find(params[:order_id])
    @book = Book.find_by_id(@order.book_id)
    @user = User.find_by(id: @order.user_id)
    if @book.is_available && @order.present?
      @order.update(status: 1)
      @book.update(is_available: false)
      render json: {message: "Accepted Order"}
      UserMailer.accepted(@user, @book).deliver_later
    else
      error = "Out of stock for #{@book.title}"
      render json: error, status: :precondition_failed
    end
  end

  #Update order's status to "rejected"
  def reject
    @order = Order.find(params[:order_id])
    @user = User.find_by(id: @order.user_id)
    @order.update(status: 2)
    @book = Book.find_by_id(@order.book_id)
    render json: {message: "Rejected Order"}
    UserMailer.rejected(@user, @book).deliver_later
  end

  #Updates order's status to "returned" and book is_available to true
  def return
    @order = Order.find(params[:order_id])
    @error = "Book was already returned to shelf" if @order.status == "returned"
    @error = "you must have accepted this order to return it" if @order.status == "pending" || @order.status == "rejected"
    if @error.present?
      render json: @error, status: :precondition_failed
    else
    @user = @order.user
    @order.update(status: 3)
    @book = Book.find_by_id(@order.book_id)
    @book.update(is_available: true)
    UserMailer.returned(@user, @book).deliver_later
    render json: {message: "Returned book to shelf"}
    end
  end

  def show
    @order = Order.find(params[:id])
    render json: {order: OrderSerializer.new(@order), book: Book.find(@order.book_id).title}
  end

  def new
    @order = Order.new
  end

  def create
    @user = current_user
    @book = Book.find(params[:order][:book_id])
    @error = "Please return your book first" if  @user.orders.last.present? && (@user.orders.last.status == "accepted" || @user.orders.last.status == "late")
    @error = "Your past order is still pending" if @user.orders.last.present? && @user.orders.last.status == "pending" 
    @error = "#{@book.title} Book is out of stock" if !@book.is_available
    @error = "Please Select a valid return date" if params[:order][:return_date].to_datetime <= Date.current
    if @error.present?
      render json: @error, status: :precondition_failed
    else
      @order = Order.new(order_params)
      @order.update(user_id: current_user.id, book_id: @book.id )
     if @order.save
        render json: @order
     else
        render json: @order.errors, status: :unprocessable_entity
      end
    end
  end

  def update
      if @order.update(order_params)
        render json: "Order updated successfully"
      else
        render json: "Order failed to update"
      end
  end

  def destroy
    @order.destroy!
    render json: "Order deleted succesfully", status: :ok
  end

  private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status, :user_id, :book_id, :return_date)
    end
    
end
