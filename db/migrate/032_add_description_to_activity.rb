class AddDescriptionToActivity < ActiveRecord::Migration
  def self.up

    add_column :activities, :description, :string
    add_column :activities, :position, :integer
    
    Activity.enumeration_model_updates_permitted = true
    a = Activity.find 1
    a.name = 'see'
    a.description = 'See it'
    a.position = 1
    a.save

    a = Activity.find 3
    a.name = 'do'
    a.description = 'Do it'
    a.position = 2
    a.save
        
    a = Activity.find 2
    a.name = 'shop'
    a.description = 'Shop it'
    a.position = 3
    a.save
    
    a = Activity.find 4
    a.name = 'find'
    a.description = 'Find it'
    a.position = 4
    a.save
  end

  def self.down
    remove_column :activities, :position
    remove_column :activities, :description
  end
end
