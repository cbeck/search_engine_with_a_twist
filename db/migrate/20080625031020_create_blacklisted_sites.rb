class CreateBlacklistedSites < ActiveRecord::Migration
  def self.up
    create_table :blacklisted_sites do |t|
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :blacklisted_sites
  end
end
