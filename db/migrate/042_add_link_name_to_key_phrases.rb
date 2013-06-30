class AddLinkNameToKeyPhrases < ActiveRecord::Migration
  def self.up
    add_column :key_phrases, :link_name, :string
    
    KeyPhrase.find(:all).each do |phrase|
      phrase.save
    end
    
  end

  def self.down
    remove_column :key_phrases, :link_name
  end
end
