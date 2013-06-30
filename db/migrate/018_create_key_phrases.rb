class CreateKeyPhrases < ActiveRecord::Migration
  def self.up
    create_table :key_phrases do |t|
      t.string :phrase

      t.timestamps
    end
  end

  def self.down
    drop_table :key_phrases
  end
end
