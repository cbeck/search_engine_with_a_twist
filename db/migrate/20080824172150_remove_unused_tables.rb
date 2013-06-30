class RemoveUnusedTables < ActiveRecord::Migration
  def self.up
    drop_table :open_id_associations
    drop_table :open_id_nonces
    drop_table :open_id_settings
    drop_table :payments
    drop_table :phones
    drop_table :taggings
    drop_table :tags
    drop_table :locations
    drop_table :categories
  end

  def self.down
  end
end
