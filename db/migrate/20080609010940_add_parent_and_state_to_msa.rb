class AddParentAndStateToMsa < ActiveRecord::Migration
  def self.up
    change_table :metro_service_areas do |t|
      t.integer :parent_id
      t.string :flash_filename
    end
  end

  def self.down
    change_table :metro_service_areas do |t|
      t.remove :parent_id
      t.remove :flash_filename
    end
  end
end
