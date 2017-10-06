class AddFieldsToUsers < ActiveRecord::Migration[5.0]
  def change
  	change_table :users do |t|
  	t.string :full_name
  	t.string :phone
  	t.string :device_id
  	t.string :token
  	t.string :device_type
  	t.string :auth_token
  end
  end
end
