class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :verified?
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]




  def index
    @books = Book.all.order(:title)
    render json: @books
  end

  def show
    @book = Book.find(params[:id])
    render json: @book
  end

  #def borrow
   # @book = Book.find(params[:book_id])
   # @last = current_user.orders.last
    #if @book.stock > 0 && @last.status != "accepted" && @last.status != "pending"
      #@order = Order.create(book_id: @book.id, status: "pending", user_id: current_user.id, return_date: Date.current)
     # if @order.save
      #  render json: @order
     # else
     #   render json: @order.errors, status: :unprocessable_entity
     # end
    #elsif @book.stock <= 0
     # error = "#{@book.title} Book is out of stock"
     # render json: error
    #elsif @last.status == "accepted"
     # error = "Please return your book first"
     # render json: error
   # else
   # error = "Your past order is still pending"
    #  render json: error
 #  end
 # end


  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
      @shelf = @book.shelf

        if  !@shelf.nil? && @shelf.current_capacity >= @shelf.max_capacity
          @book.delete
          error = "Shelf is out of storage"
          render json: error
        else
          if @book.save
            @shelf = @book.shelf
            @now = @shelf.current_capacity
            @shelf.update(current_capacity: @now + 1)
            render json: @book, status: :created, location: @book
          else
            render json: @book.errors, status: :unprocessable_entity
        end
      end
  end

  def update

      if @book.update(book_params)
        render json: @book
      else
        render json: {message: "error"}
    end
  end

  def destroy
    if @book.destroy!
      render json: {message: "success"}
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :shelf_id ,:stock, :rating, :author_id, category_ids: [])
    end
end
