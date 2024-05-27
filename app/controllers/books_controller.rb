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
       if @shelf.current_capacity >= @shelf.max_capacity 
        render json: {message: "#{@book.shelf.name} is out of storage"}
       else
        if @book.save
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
    #render json: 'error' if @new_shelf == @old_shelf
    @error = "Shelf #{@new_shelf.name} is out of storage" if !@new_shelf.nil? && @new_shelf.current_capacity == @new_shelf.max_capacity 
    @error = "Book #{@book.title} is already on shelf #{@new_shelf.name}" if @new_shelf == @old_shelf
    if @error.present?
    render json: @error
    else
    if @book.update(book_params)
          render json: @book
        else
          render json: {message: "error"}
        end
      end
  end

  def destroy
     @shelf = @book.shelf
    if @book.destroy!
      @shelf.update(current_capacity: @shelf.current_capacity - 1)
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
