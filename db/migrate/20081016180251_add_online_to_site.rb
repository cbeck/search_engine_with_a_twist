class AddOnlineToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :online, :boolean, :default => 0
    
    msa = MetroServiceArea.find_by_name("Online")
    msa.sites.each do |s|
      s.online = true
      link_name = (s.city.nil? || s.city=="Online") ? nil : s.city.tr("^[A-Za-z]", "").downcase      
      s.metro_service_area = (link_name.nil?) ? nil : MetroServiceArea.find_by_link_name(link_name)
      s.save
    end
  end

  def self.down
    remove_column :table_name, :column_name
  end
end
