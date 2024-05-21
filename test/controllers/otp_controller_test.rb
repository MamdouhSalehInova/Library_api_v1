require "test_helper"

class OtpControllerTest < ActionDispatch::IntegrationTest
  test "should get verify" do
    get otp_verify_url
    assert_response :success
  end
end
