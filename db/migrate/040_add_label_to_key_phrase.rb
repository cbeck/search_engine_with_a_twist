class AddLabelToKeyPhrase < ActiveRecord::Migration
  def self.up
    add_column :key_phrases, :label, :string
  end

  def self.down
    remove_column :key_phrases, :label
  end
end
