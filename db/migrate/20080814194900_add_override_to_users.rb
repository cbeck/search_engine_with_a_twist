class AddOverrideToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :ub_override  #values ubexactor, ubexpert or nil - yes, i have a reason
    end
  end

  def self.down
    t.remove :ub_override
  end
end
