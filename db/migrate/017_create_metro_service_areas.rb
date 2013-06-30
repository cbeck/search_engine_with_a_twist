class CreateMetroServiceAreas < ActiveRecord::Migration
  def self.up
    create_table :metro_service_areas do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :metro_service_areas
  end
end
