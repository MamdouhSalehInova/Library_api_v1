class Users::RegistrationsController < ApplicationController
  respond_to :json

  def create
    user = User.new(email: params[:user][:email], password: params[:user][:password])
    if user.save
      #token = user.generate_jwt
      render json: {message: "Signed up successfully"}
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end
  
  private

  def respond_with(resource, _opts = {})
    if request.method == "POST" && resource.persisted?
      render json: {
        status: {code: 200, message: "Signed up sucessfully."},
        data: UserSerializer.new(resource)
      }, status: :ok
    elsif request.method == "DELETE"
      render json: {
        status: { code: 200, message: "Account deleted successfully."}
      }, status: :ok
    else
      render json: {
        status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end
