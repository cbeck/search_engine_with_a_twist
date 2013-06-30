class AddActivityToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :activity_id, :integer
    Activity.enumeration_model_updates_permitted = true
    Activity.create :name => 'See it'
    Activity.create :name => 'Shop it'
    Activity.create :name => 'Do it'
    Activity.create :name => 'Find it'
  end

  def self.down
    remove_column :sites, :activity_id
  end
end
