class AddTopicToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :topic_id, :integer
    add_column :topics, :parent_id, :integer
  end

  def self.down
    remove_column :topics, :parent_id
    remove_column :sites, :topic_id
  end
end
