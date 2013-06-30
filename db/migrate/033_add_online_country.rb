class AddOnlineCountry < ActiveRecord::Migration
  def self.up
    Country.create :name => 'ONLINE', :code => 'ON'
  end

  def self.down
    Country.find_by_name("ONLINE").destroy
  end
end
