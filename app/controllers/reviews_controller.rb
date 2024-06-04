class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show update destroy ]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :verified?

  def index
    @reviews = Review.page(params[:page]).per(params[:page_size]).order(:id)
    render json: @reviews
  end

  def show
    @review = Review.find(params[:id])
    render json: @review
  end

  def create
    @user = current_user
    @book = Book.find(params[:review][:book_id])
    @error = "you must've had ordered this book and returned it before to write a review about it" if !@user.orders.where(book_id: @book.id, status: 3).present?
    @error = "You have already reviewed this book" if @book.reviews.find_by(user_id: current_user.id) 
      if @error.present?
        render json: @error, status: :precondition_failed
      else
        @review = Review.new(review_params)
        @review.update(user_id: @user.id, book_id: @book.id)
        if @review.save
          render json: @review
        else
          render json: @review.errors, status: :unprocessable_entity
        end
      end
  end
  

  def update
    if @review.user.email == current_user.email
      if @review.update(review_params)
        render json: @review, status: :ok, location: @review
      else
        render json: @review.errors, status: :unprocessable_entity
      end
    else
      render json: {message: "You cant edit other's reviews"}, status: :forbidden
    end

  end

  def destroy
    if @review.user.email == current_user.email
      @review.destroy!
      render json: {message: "Review deleted succefully"}
    else
      error = "you cant delete other's reviews"
      render json: error, status: :forbidden
    end
  end

  private

    def set_review
      @review = Review.find(params[:id])
    end

    def review_params
      params.require(:review).permit(:body,:user_id, :book_id, :rating)
    end
end
