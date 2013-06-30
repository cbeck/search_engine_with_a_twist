class AddSiteToKeyPhrase < ActiveRecord::Migration
  def self.up
    add_column :key_phrases, :site_id, :integer
  end

  def self.down
    remove_column :key_phrases, :site_id
  end
end
