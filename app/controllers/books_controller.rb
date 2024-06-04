class BooksController < ApplicationController
  before_action :set_book, only: %i[ show update destroy ]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :verified?
  before_action :admin?, only: [ :destroy, :create, :update]

  def index
    @books = Book.includes(:author, :shelf, :reviews, :books_categories, :categories).page(params[:page]).per(params[:page_size]).order(:title)
    render json: @books
  end

  def show
    @book = Book.find(params[:id])
    render json: {Book: BookSerializer.new(@book)}
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
    if params[:book][:shelf_id].present?
      @new_shelf = Shelf.find(params[:book][:shelf_id])
      @error = "Book #{@book.title} is already on shelf #{@new_shelf.name}" if @new_shelf == @book.shelf
      @error = "Shelf #{@new_shelf.name} is out of storage" if @new_shelf.current_capacity == @new_shelf.max_capacity 
    end
    if @error.present?
      render json: @error
    else
      if @book.update(book_params)
        render json: @book, status: :ok
      else
        render json: @book.errors, status: :unprocessable_entity
      end
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
      params.require(:book).permit(:title, :shelf_id, :rating, :author_id, category_ids: [])
    end

end
