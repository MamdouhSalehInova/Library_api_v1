require "test_helper"

class PasswordMailerTest < ActionMailer::TestCase
  test "reset" do
    mail = PasswordMailer.reset
    assert_equal "Reset", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["railstest22@gmail.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "changed" do
    mail = PasswordMailer.changed
    assert_equal "Changed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["railstest22@gmail.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
