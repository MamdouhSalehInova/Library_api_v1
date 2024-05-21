class AddOtpCodeToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :otp_code, :integer
  end
end
