class AddAltTextToActivities < ActiveRecord::Migration
  def self.up
    change_table :activities do |t|
      t.string :alt_text
    end    
  end

  def self.down
    change_table :activities do |t|
      t.remove :alt_text
    end
  end
end
