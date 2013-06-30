class AddAdContextToKeyphrases < ActiveRecord::Migration
  def self.up
    change_table :key_phrases do |t|
      t.string :ad_context
    end
  end

  def self.down
    change_table :key_phrases do |t|
      t.remove :ad_context
    end
  end
end
