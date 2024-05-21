require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "accepted" do
    mail = UserMailer.accepted
    assert_equal "Accepted", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "rejected" do
    mail = UserMailer.rejected
    assert_equal "Rejected", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
