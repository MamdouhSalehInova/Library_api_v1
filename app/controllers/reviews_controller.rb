class ReviewsController < ApplicationController
  respond_to :json
  before_action :set_review, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :verified?


  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
    render json: @reviews
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
    @review = Review.find(params[:id])
    render json: @review
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @user = current_user
    @book = Book.find(params[:review][:book_id])
    if @user.orders.where(book_id: @book.id, status: 3).present?
      @review = Review.new(review_params)
      @review.update(user_id: @user.id)
      @review.update(book_id: @book.id)
      if @review.save
        render json: @review
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    else
      error= "you must've had ordered this book and returned it before to write a review about it"
      render json: error
    end

  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    if @review.user.email == current_user.email
      if @review.update(review_params)
        render json: @review, status: :ok, location: @review
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    else
      render json: {message: "You cant edit other's reviews"}
    end

  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    if @review.user.email == current_user.email
      @review.destroy!
      render json: {message: "Review deleted succefully"}
    else
      error = "you cant delete other's reviews"
      render json: error
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:body,:user_id, :book_id, :rating)
    end
end
