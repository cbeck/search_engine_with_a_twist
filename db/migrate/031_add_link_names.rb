class AddLinkNames < ActiveRecord::Migration
  def self.up
    add_column :topics, :link_name, :string
    
    Topic.find(:all).each do |topic|
      topic.name = "Other" if topic.name.nil?
      topic.save
    end
    
    add_column :metro_service_areas, :link_name, :string
    
    MetroServiceArea.find(:all).each do |msa|
      msa.name = "Other" if msa.name.nil?
      msa.save
    end
    
  end

  def self.down
    remove_column :metro_service_areas, :link_name
    remove_column :topics, :link_name
  end
end
