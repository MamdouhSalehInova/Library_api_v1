class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]
  before_action :verified?

  def index
    @authors = Author.page(params[:page]).order(:name)
    render json: {data: { authors: @authors.map{|author| author.as_serialized_json}}}
  end

  def show
    @author = Author.find(params[:id])
    render json: {data: {author: {data: @author.as_serialized_json, books: @author.books.map{|book| book.as_serialized_json}}}}
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
      if @author.save
        render json: @author, status: :created, location: @author
      else
        render json: @author.errors, status: :unprocessable_entity
      end
  end

  def update
      if @author.update(author_params)
        render json: {author: @author, status: :ok, message: "author updated successfully" }
      else
        render json: @author.errors, status: :unprocessable_entity
      end
  end

  def destroy
    if @author.destroy!
      render json: {author: @author, status: :ok, message: "author deleted successfully" }
      else
        render json: @author.errors, status: :unprocessable_entity
      end
  end

  def edit
  end

  private

    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name)
    end
end
