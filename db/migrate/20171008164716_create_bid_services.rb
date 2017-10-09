class CreateBidServices < ActiveRecord::Migration[5.0]
  def change
    create_table :bid_services do |t|
     t.integer :bid_id
      t.integer :service_id

      t.timestamps
    end
  end
end
