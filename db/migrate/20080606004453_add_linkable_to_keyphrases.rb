class AddLinkableToKeyphrases < ActiveRecord::Migration
  def self.up
    add_column :key_phrases, :linkable, :boolean
  end

  def self.down
    remove_column :key_phrases, :linkable
  end
end
