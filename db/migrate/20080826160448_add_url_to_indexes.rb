class AddUrlToIndexes < ActiveRecord::Migration
  def self.up
    add_index :sites, :url
    add_index :blacklisted_sites, :url
  end

  def self.down
    remove_index :sites, :url
    remove_index :blacklisted_sites, :url
  end
end
