class AddColumnsToPeople < ActiveRecord::Migration
  def self.up
    change_table :people do |t|
      t.string :city
      t.string :country
      t.string :birth_year
      t.string :url
      t.text :description
      t.boolean :agreed_to_terms
    end
  end

  def self.down
    change_table :people do |t|
      t.remove :city
      t.remove :country
      t.remove :birth_year
      t.remove :url
      t.remove :description
      t.remove :agreed_to_terms
    end
  end
end
