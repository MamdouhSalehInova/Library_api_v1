class ShelvesController < ApplicationController
  before_action :set_shelf, only: %i[ show edit update destroy ]
  before_action :admin?, only: [ :edit, :destroy, :new, :create, :update]
  before_action :check_capacity, only: [:show]
  before_action :verified?

  def index
    @shelves = Shelf.all.order(:name)
    render json: @shelves
  end

  def check_capacity
    @shelf = Shelf.find(params[:id])
    if @shelf.max_capacity == @shelf.current_capacity
      notice = "Shelf #{@shelf} is full!"
      render json: notice
    end
  end

  def show
    @shelf = Shelf.find(params[:id])
    @books = Book.where(shelf_id: @shelf.id)
    render json: {Shelf: ShelfSerializer.new(@shelf), Books: @shelf.books}
  end

  def new
    @shelf = Shelf.new

  end

  def edit
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

  private

    def set_shelf
      @shelf = Shelf.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def shelf_params
      params.require(:shelf).permit(:name, :max_capacity, :id, :current_capacity)
    end
end
