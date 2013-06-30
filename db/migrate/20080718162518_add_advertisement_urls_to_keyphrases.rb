class AddAdvertisementUrlsToKeyphrases < ActiveRecord::Migration
  def self.up
    change_table :key_phrases do |t|
      t.string :advertisement_url
    end
  end

  def self.down
    change_table :key_phrases do |t|
      t.remove :advertisement_url
    end
  end
end
