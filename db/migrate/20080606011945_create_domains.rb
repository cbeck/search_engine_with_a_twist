class CreateDomains < ActiveRecord::Migration
  def self.up
    create_table :domains do |t|
      t.string :url
      t.string :phrase
      t.string :link_name

      t.timestamps
    end
    
    add_column :topics, :domain_id, :integer
    add_column :key_phrases, :domain_id, :integer
    add_column :metro_service_areas, :domain_id, :integer

  end

  def self.down
    remove_column :metro_service_areas, :domain_id
    remove_column :key_phrases, :domain_id
    remove_column :topics, :domain_id
    drop_table :domains
  end
end
