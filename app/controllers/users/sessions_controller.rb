class Users::SessionsController < ApplicationController
  include RackSessionsFix
  respond_to :json

  def create
    user = User.find_by_email(params[:user][:email])
    if Session.find_by(user_id: user.id).present?
      render json: {
        message: "You are already logged in"}
    else
      if user && user.valid_password?(params[:user][:password])
        user.update(otp_code: SecureRandom.rand(10000..99999))
        SendOtpService.new(user).call
        token = user.generate_jwt
        Session.create(user_id: user.id, token: token)
        render json: {
          message: "Otp Sent To #{user.email}", 
          user: user.as_serialized_json,
          access_token: token
        }
      else
        render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
      end
    end
  
  end

  #Creates a new session and generates a 5 digit otp code, assigned and sent to the user
  #def create
    #self.resource = warden.authenticate!(auth_options)
    #@user.update(otp_code: SecureRandom.rand(10000..99999))
    #SendOtpService.new(@user).call
    #render json: {
    #message: "Otp Sent To #{@user.email}", 
    #user: @user.as_serialized_json,
    #access_token: request.env['warden-jwt_auth.token']
  #}
  #end

  #destroys the current session and sets the user's is_verified attribute to false
  def destroy
    if Session.find_by(user_id: current_user.id).present?
      current_user.update(is_verified: false)
      token = request.headers['Authorization'].split(' ')[1]
      current_user.revoke_jwt(token)
      render json: { message: "Signed out successfully", user: current_user }, status: :ok
    else
      render json: { message: "Couldn't find an active session." }, status: :unauthorized
    end
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: {code: 200, message: 'Logged in sucessfully.'},
      data: UserSerializer.new(resource)
    }, status: :ok
  end

  def respond_to_on_destroy
    if Session.find_by(user_id: current_user.id).present?
      render json: {
        status: 200,
        message: "logged out successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "Couldn't find an active session."
      }, status: :unauthorized
    end
  end

end
