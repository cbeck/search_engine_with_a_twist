class AddUbaliasToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :ub_alias
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :ub_alias
    end
  end
end
