class AddLevelToTopic < ActiveRecord::Migration
  def self.up
    add_column :topics, :level, :integer
  end

  def self.down
    remove_column :topics, :level
  end
end
