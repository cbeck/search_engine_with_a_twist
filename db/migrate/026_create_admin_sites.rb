class CreateAdminSites < ActiveRecord::Migration
  def self.up
    create_table :admin_sites do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_sites
  end
end
