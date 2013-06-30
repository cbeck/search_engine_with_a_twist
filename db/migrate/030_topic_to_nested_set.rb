class TopicToNestedSet < ActiveRecord::Migration
  def self.up
    add_column :topics, :lft, :integer
    add_column :topics, :rgt, :integer
    add_column :topics, :root_id, :integer
    remove_column :topics, :level
    
    # Topic.renumber_all
    # Topic.roots.each do |r|
    #   r.all_children.each do |c|
    #     c.update_attribute(:root_id, r.id)
    #   end
    #   r.update_attribute(:root_id, r.id)
    # end
    
  end

  def self.down
    remove_column :topics, :root_id
    remove_column :topics, :rgt
    remove_column :topics, :lft
  end
end
