class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string :name
      t.string :url
      t.string :state
      t.string :city
      t.boolean :free
      t.boolean :registration_required
      t.text :description
      t.boolean :official

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
