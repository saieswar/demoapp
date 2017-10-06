class CreateZips < ActiveRecord::Migration[5.0]
  def change
    create_table :zips do |t|
      t.integer :zip_code
      t.string :city
      t.string :state
      t.string :country
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
