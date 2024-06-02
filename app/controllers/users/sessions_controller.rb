class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    @user.update(otp_code: SecureRandom.rand(10000..99999))
    SendOtpService.new(@user).call
    render json: {message: "Otp Sent To #{@user.email}"}
  end

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
