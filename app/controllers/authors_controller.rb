class AuthorsController < ApplicationController

  before_action :set_author, only: %i[ show edit update destroy ]
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]
  before_action :verified?




  # GET /authors or /authors.json
  def index
    @authors = Author.all
    render json: @authors
  end

  # GET /authors/1 or /authors/1.json
  def show
    @author = Author.find(params[:id])
    @books = Book.where(author_id: @author.id)

    render json: {Author: @author.name, Books: @books}
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors or /authors.json
  def create
    @author = Author.new(author_params)
      if @author.save
        render json: @author, status: :created, location: @author
      else
        render json: @author.errors, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /authors/1 or /authors/1.json
  def update

      if @author.update(author_params)
        render json: {author: @author, status: :ok, message: "author updated successfully" }
      else
        render json: @author.errors, status: :unprocessable_entity
      end

  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    if @author.destroy!
      render json: {author: @author, status: :ok, message: "author deleted successfully" }
      else
        render json: @author.errors, status: :unprocessable_entity
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_author
      @author = Author.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def author_params
      params.require(:author).permit(:name)
    end
end
