class AddPrefPaidToKeyPhrase < ActiveRecord::Migration
  def self.up
    add_column :key_phrases, :preferred, :boolean, :default => false
    add_column :key_phrases, :paid, :boolean, :default => false
  end

  def self.down
    remove_column :key_phrases, :paid
    remove_column :key_phrases, :preferred
  end
end
