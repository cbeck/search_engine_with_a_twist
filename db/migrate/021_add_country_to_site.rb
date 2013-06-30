class AddCountryToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :country_code, :string
  end

  def self.down
    remove_column :sites, :country_code
  end
end
