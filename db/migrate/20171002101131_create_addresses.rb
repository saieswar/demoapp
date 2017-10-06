class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
        t.string :address1
    	t.string :address2
    	#t.string :sub_division
    	t.integer :zip_id
    	t.string :addressable_type
    	t.integer :addressable_id
      t.timestamps
    end
  end
end
