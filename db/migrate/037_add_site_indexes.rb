class AddSiteIndexes < ActiveRecord::Migration
  def self.up
    add_index :sites, :topic_id
    add_index :sites, :metro_service_area_id
  end

  def self.down
    remove_index :sites, :metro_service_area_id
    remove_index :sites, :topic_id
    mind
  end
end
