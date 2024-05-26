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


  def new
    @book = Book.new
  end

  def edit
  end

  def create
    @book = Book.new(book_params)
      @shelf = @book.shelf
        if  !@shelf.nil? && @shelf.current_capacity == @shelf.max_capacity
          @book.delete
          error = "Shelf #{@shelf.name} is out of storage"
          render json: error
        elsif  !@shelf.nil? && @shelf.current_capacity + @book.stock > @shelf.max_capacity
          @book.delete
          error = "Shelf #{@shelf.name} cant fit all these books"
          render json: error
        else
          if @book.save
            @shelf = @book.shelf
            @now = @shelf.current_capacity
            @shelf.update(current_capacity: @now + @book.stock)
            render json: @book, status: :created, location: @book
          else
            render json: @book.errors, status: :unprocessable_entity
        end
      end
  end

  def update
    @old_shelf = @book.shelf
    if params[:book][:shelf_id].present?
      @new_shelf = Shelf.find(params[:book][:shelf_id])
    end
    if params[:book][:stock].present?
      @old_stock = @book.stock
    end

    if @new_shelf == @old_shelf
      error = "Book #{@book.title} is already on shelf #{@new_shelf.name}"
      render json: error
    else
      if !@new_shelf.nil? && @new_shelf.current_capacity == @new_shelf.max_capacity
        error = "Shelf #{@new_shelf.name} is out of storage"
        render json: error
      elsif  !@new_shelf.nil? && @new_shelf.current_capacity + @book.stock > @new_shelf.max_capacity
        error = "Shelf #{@new_shelf.name} cant fit all these books"
        render json: error
        elsif params[:book][:stock].present? && params[:book][:shelf_id].present? &&
           params[:book][:stock] + Shelf.find(params[:book][:shelf_id]).current_capacity > Shelf.find(params[:book][:shelf_id]).max_capacity
           error = "Shelf #{Shelf.find(params[:book][:shelf_id]).name} cant fit all these books"
           render json: error
           elsif params[:book][:stock].present? && @book.shelf.current_capacity - @old_stock + params[:book][:stock] > @book.shelf.max_capacity
            error = "Shelf #{@book.shelf.name} cant fit all these books"
           render json: error
      else
        if @book.update(book_params)
          if  @new_shelf.present? && @old_stock.present?
            @old_shelf.update(current_capacity: @book.shelf.current_capacity - @old_stock)
            @old_shelf.update(current_capacity: @book.shelf.current_capacity + @book.stock)
            @new_shelf.update(current_capacity: @new_shelf.current_capacity + @book.stock)
            @old_shelf.update(current_capacity: @old_shelf.current_capacity - @book.stock)
          elsif @new_shelf.present?
            @new_shelf.update(current_capacity: @new_shelf.current_capacity + @book.stock)
            @old_shelf.update(current_capacity: @old_shelf.current_capacity - @book.stock)
          elsif @old_stock.present?
            @book.shelf.update(current_capacity: @book.shelf.current_capacity - @old_stock)
            @book.shelf.update(current_capacity: @book.shelf.current_capacity + @book.stock)
          end
          render json: @book
        else
          render json: {message: "error"}
        end
      end
    end
  end

  def destroy
     @shelf = @book.shelf
     @book_stock = @book.stock
    if @book.destroy!
      @shelf.update(current_capacity: @shelf.current_capacity - @book_stock)
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
