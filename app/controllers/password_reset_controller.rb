class PasswordResetController < ApplicationController

  def create
    @user = User.find_by(email: user_params[:email])
    if @user.present?
      @user.update(reset_password_token: SecureRandom.hex )
      PasswordMailer.reset(@user).deliver_later
      render json: {message: "Password reset instruction sent to #{@user.email}"}
    else
      render json: {message: "Invalid email"}
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:reset_password_token])
    @user.update(password: params[:user][:password])
    if @user.save
      PasswordMailer.changed(@user).deliver_later
      render json: {message: "Password updated successfully"}
    else
      render json: @user.errors
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :reset_password_token)
  end
end
