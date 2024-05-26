class OrdersController < ApplicationController
  before_action :set_order, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:my_orders, :create, :update]
  before_action :admin?, only: [ :index ,:accept, :reject, :return, :late, :edit, :destroy, :update, :show]
  before_action :verified?


  respond_to :json

  # GET /orders or /orders.json
  def index
    @orders = Order.all
    render json: @orders
  end



  def late
    @orders = Order.all
    @late_orders = @orders.where(status: 5)
    render json: @late_orders
  end

  def my_orders
    @orders = current_user.orders
    render json: @orders.order(:id), each_serializer: OrderSerializer
  end

  def accept
    @order = Order.find(params[:order_id])
    @book = Book.find_by_id(@order.book_id)
    @user = User.find_by(id: @order.user_id)
    @shelf = @book.shelf
    if @book.stock > 0 && @order.present?
      @shelf.update(current_capacity: @shelf.current_capacity - 1)
      @order.update(status: 1)
      @book.update(stock: @book.stock - 1)
      render json: {message: "Accepted Order"}
      UserMailer.accepted(@user).deliver_later
    else
        error = "Out of stock for #{@book.title}"
        render json: error
    end
  end


  def reject
    @order = Order.find(params[:order_id])
    @user = User.find_by(id: @order.user_id)
    @order.update(status: 2)
    render json: {message: "Rejected Order"}
    UserMailer.rejected(@user).deliver_later
  end



  def return
    @order = Order.find(params[:order_id])
    @user = @order.user
    @order.update(status: 3)
    @order.save
    @book = Book.find_by_id(@order.book_id)
    @book.update(stock: @book.stock + 1)
    @shelf = Shelf.find_by(id: @book.shelf_id)
    @shelf.update(current_capacity: @shelf.current_capacity + 1)
    UserMailer.returned(@user).deliver_later
    render json: {message: "Returned book to shelf"}
  end

  # GET /orders/1 or /orders/1.json
  def show
    @order = Order.find(params[:id])
    render json: {order: OrderSerializer.new(@order), user: UserSerializer.new(@order.user), book: Book.find(@order.book_id).title, stock: Book.find(@order.book_id).stock}
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @book = Book.find(params[:order][:book_id])
    @check_accepted = current_user.orders.where(status: 1).last
    @check_pending = current_user.orders.where(status: 0).last
    @order.update(user_id: current_user.id, book_id: @book.id )
    @admins = User.where(is_admin: true)
    if @book.stock > 0 && !@check_accepted.present? && !@check_pending.present?
     if @order.save
        @order.update(status: 0)
        render json: @order
        @admins.each do |admin|
        AdminMailer.new_order(admin).deliver_later
        end
     else
        render json: @order.errors, status: :unprocessable_entity
      end
    elsif @book.stock <= 0
      @order.delete
      error = "#{@book.title} Book is out of stock"
      render json: error
    elsif @check_accepted.present?
      @order.delete
      error = "Please return your book first"
      render json: {measage: error, order:  OrderSerializer.new(@check_accepted)}
    elsif @check_pending.present?
      @order.delete
      Order.where(status: nil).delete_all
      error = "Your past order is still pending"
      render json: {measage: error, order:  OrderSerializer.new(@check_pending)}
    elsif @order.return_date <= Date.current
      @order.delete
      error = "Please select a valid return date"
      render json: {measage: error, order:  OrderSerializer.new(@order)}
   end
  end

  # PATCH/PUT /orders/1 or /orders/1.json
  def update
      if @order.update(order_params)
        render json: {message: "success"}
      else
        render json: {message: "failed"}
      end
  end

  # DELETE /orders/1 or /orders/1.json
  def destroy
    @order.destroy!
    render json: {message: "success"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def order_params
      params.require(:order).permit(:status,:user_id, :book_id, :return_date)
    end
end
