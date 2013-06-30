class CreateLinkNameIndexes < ActiveRecord::Migration
  def self.up
    add_index :metro_service_areas, :link_name
    add_index :topics, :link_name
  end

  def self.down
    remove_index :topics, :link_name
    remove_index :metro_service_areas, :link_name
  end
end
