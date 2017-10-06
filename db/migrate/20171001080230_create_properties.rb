class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.integer  :seller_id
      t.integer  :property_type_id
      t.integer  :structure_size
      t.integer  :bedrooms
      t.float    :bathrooms
      t.integer  :basement_type_id
      t.float    :lot_size
      t.integer  :year_built
      t.integer  :est_sale_price
      t.string   :listing_type
      t.string   :status
      t.integer  :response_count
      t.boolean  :active,               default: true
      t.date     :list_end_date
      t.boolean  :garage
      t.boolean  :pool
      t.boolean  :water_front
      t.string   :garage_doors
      t.string   :lot_size_units
      t.boolean  :buy_another_property, default: false
      t.string   :reject_notes
      t.text     :additional_note
      t.timestamps
    end
  end
end
