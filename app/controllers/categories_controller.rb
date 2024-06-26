class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show edit update destroy ]
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]
  before_action :verified?

  def index
    @categories = Category.page(params[:page]).per(params[:page_size]).order(:name)
    render json: {data: {categories: @categories.map{|category| category.as_serialized_json}}}
  end

  def show
    @category = Category.find(params[:id])
    render json: {data: {category: {data: @category.as_serialized_json, books: @category.books.map{|book| book.as_serialized_json}}}}
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
      if @category.save
        render json: @category, status: :created, location: @category
      else
        render json: @category.errors, status: :unprocessable_entity
      end

  end

  def update
      if @category.update(category_params)
        render json: {category: @category}
      else
        render json: @category.errors, status: :unprocessable_entity
      end
  end

  def destroy
    if @category.destroy!
      render json: {message: "success"}
    end
  end

  def edit
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, book_ids: [])
    end
end
