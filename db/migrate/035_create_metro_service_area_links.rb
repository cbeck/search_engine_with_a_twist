class CreateMetroServiceAreaLinks < ActiveRecord::Migration
  def self.up
    create_table :metro_service_area_links do |t|
      t.integer :metro_service_area_id
      t.string :name
      t.string :url
      t.timestamps
    end
  end

  def self.down
    drop_table :metro_service_area_links
  end
end
