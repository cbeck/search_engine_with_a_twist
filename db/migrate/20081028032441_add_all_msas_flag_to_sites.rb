class AddAllMsasFlagToSites < ActiveRecord::Migration
  def self.up
    change_table :sites do |t|
      t.boolean :all_msas, :default => 0
    end
  end

  def self.down
    change_table :sites do |t|
      t.remove :all_msas
    end
  end
end
