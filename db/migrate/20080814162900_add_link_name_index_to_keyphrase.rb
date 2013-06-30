class AddLinkNameIndexToKeyphrase < ActiveRecord::Migration
  def self.up
    add_index :key_phrases, :link_name
  end

  def self.down
    remove_index :key_phrases, :link_name
  end
end
