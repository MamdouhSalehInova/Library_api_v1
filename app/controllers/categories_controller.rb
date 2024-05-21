class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]
  before_action :verified?

  # GET /categories or /categories.json
  def index
    @categories = Category.all
    render json: @categories
  end

  # GET /categories/1 or /categories/1.json
  def show
    @category = Category.find(params[:id])
    @books = @category.books
    render json: {@category.name => @books}
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories or /categories.json
  def create
    @category = Category.new(category_params)
      if @category.save
        render json: @category, status: :created, location: @category
      else
        render json: @category.errors, status: :unprocessable_entity
      end

  end

  # PATCH/PUT /categories/1 or /categories/1.json
  def update

      if @category.update(category_params)
        render json: {category: @category}
      else
        render json: @category.errors, status: :unprocessable_entity
      end

  end

  # DELETE /categories/1 or /categories/1.json
  def destroy
    if @category.destroy!
      render json: {message: "success"}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:name, book_ids: [])
    end
end
