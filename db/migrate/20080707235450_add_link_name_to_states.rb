class AddLinkNameToStates < ActiveRecord::Migration  
  def self.up
    add_column :states, :link_name, :string
  
    states = State.find(:all)
    states.each {|state|
      link_name = state.name.tr("^[A-Za-z]", "").downcase
      state.update_attributes :link_name => link_name
    }
  
    dc = State.find_by_name("District of Columbia")
    dc.update_attributes :link_name => "washingtondc"
  end

  def self.down
    remove_column :states, :link_name
  end
end