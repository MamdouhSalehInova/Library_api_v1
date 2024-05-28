require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "new_order" do
    mail = AdminMailer.new_order
    assert_equal "New order", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["railstest22@gmail.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
