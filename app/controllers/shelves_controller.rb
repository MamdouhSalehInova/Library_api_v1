class ShelvesController < ApplicationController
  before_action :set_shelf, only: %i[ show edit update destroy ]
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]
  before_action :verified?

  def index
    @shelves = Shelf.page(params[:page]).per(params[:page_size]).order(:name)
    render json: {data: {shelves: @shelves.map{|shelf| shelf.as_serialized_json}}}
  end

  def show
    @shelf = Shelf.find(params[:id])
    @books = Book.where(shelf_id: @shelf.id)
    render json: {data: {shelf: @shelf.as_serialized_json, books: @shelf.books.map{|book| book.as_serialized_json}}}
  end

  def new
    @shelf = Shelf.new
  end

  def create
    @shelf = Shelf.new(shelf_params)
      if @shelf.save
        render json: @shelf, status: :created, location: @shelf
      else
        render json: @shelf.errors, status: :unprocessable_entity
      end
  end

  def update
      if @shelf.update(shelf_params)
        render json: @shelf
      else
        render json: @shelf.errors, status: :unprocessable_entity
      end
  end

  def destroy
    if @shelf.destroy!
      render json: {message: "success"}
    end
  end

  def edit
  end

  private

    def set_shelf
      @shelf = Shelf.find(params[:id])
    end

    def shelf_params
      params.require(:shelf).permit(:name, :max_capacity, :id, :current_capacity)
    end
end
