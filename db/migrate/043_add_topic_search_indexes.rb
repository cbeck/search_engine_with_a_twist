class AddTopicSearchIndexes < ActiveRecord::Migration
  def self.up
    add_index :key_phrases, :site_id
    
    add_index :topics, :lft
    add_index :topics, :rgt
    add_index :topics, :root_id
  end

  def self.down
    remove_index :topics, :root_id
    remove_index :topics, :rgt
    remove_index :topics, :lft
    remove_index :key_phrases, :site_id
    
    mind
  end
end
