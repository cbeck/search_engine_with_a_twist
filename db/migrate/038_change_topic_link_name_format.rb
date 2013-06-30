class ChangeTopicLinkNameFormat < ActiveRecord::Migration
  def self.up
    Topic.find(:all).each do |topic|
      # changes topic.link_name to not use underscores (using before_save)
      # i.e. auto_vehicles => autovehicles
      topic.save
    end
  end

  def self.down
  end
end
