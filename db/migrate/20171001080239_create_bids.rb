class CreateBids < ActiveRecord::Migration[5.0]
  def change
    create_table :bids do |t|
        t.float :bid_percentage
    	t.integer :est_asking_price
    	t.integer :property_id
    	t.integer :bid_status_id
    	t.integer :agent_id
    	t.boolean :sent_to_owner
    	t.date :bid_end_date
    	t.boolean :is_open
    	t.text :message
    	t.datetime :bid_accepted_at
    	t.float :buyer_percentage
    	t.string :notification_sent
      t.timestamps
    end
  end
end
