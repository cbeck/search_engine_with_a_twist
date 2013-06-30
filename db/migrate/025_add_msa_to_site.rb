class AddMsaToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :metro_service_area_id, :string
  end

  def self.down
    remove_column :sites, :metro_service_area_id
  end
end
