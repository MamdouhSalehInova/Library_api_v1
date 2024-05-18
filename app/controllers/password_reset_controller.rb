class PasswordResetController < ApplicationController

  def create
    @user = User.find_by(email: user_params[:email])
    if @user.present?
      @user.update(reset_password_token: SecureRandom.hex )
      PasswordMailer.reset(@user).deliver_now
    end
    render json: @user.id
  end

  def edit
    @user = User.where(reset_password_token: params[:reset_password_token]).first
    @user.update(password: params[:user][:password])
    if @user.save
      PasswordMailer.changed(@user).deliver_now
    end

  end

  def user_params
    params.require(:user).permit(:email, :password, :reset_password_token)
  end
end
