class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    user = User.find_by_email(sign_in_params[:email])
    if user && user.valid_password?(sign_in_params[:password])
      user.update(otp_code: SecureRandom.rand(10000..99999))
      SendOtpService.new(user).call
      token = user.generate_jwt
      render json: {
        message: "Otp Sent To #{user.email}", 
        user: user.as_serialized_json,
        access_token: token
      }
    else
      render json: { errors: { 'email or password' => ['is invalid'] } }, status: :unprocessable_entity
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
    @user = current_user
    @user.update(is_verified:false)
     super
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      status: {code: 200, message: 'Logged in sucessfully.'},
      data: UserSerializer.new(resource)
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      @user = current_user
      @user.update(is_verified: false)
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
