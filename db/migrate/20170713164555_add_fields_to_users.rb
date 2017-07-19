class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
  	change_table :users do |t|
  	t.string :first_name
  	t.string :last_name
  	t.datetime :date_of_birth
  	t.string :otp_token
  	t.string :phone
  	t.string :device_id
  	t.string :token
  	t.string :device_type
  	t.string :auth_token
  end
  end
end
