class AddAdvertisementFlagsToSite < ActiveRecord::Migration
  def self.up
    change_table :sites do |t|
      t.boolean :ad_only
      t.boolean :restrict_to_msa
    end
  end

  def self.down
    change_table :sites do |t|
      t.remove :ad_only
      t.remove :restrict_to_msa
    end
  end
end
