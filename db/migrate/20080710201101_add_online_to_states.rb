class AddOnlineToStates < ActiveRecord::Migration
  def self.up
    State.create(:name=>"ONLINE", :code=>"ON", :link_name=>"online")
  end

  def self.down
    State.find_by_name("ONLINE").destroy
  end
end
