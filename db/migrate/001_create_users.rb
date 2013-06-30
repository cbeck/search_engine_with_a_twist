require 'faster_csv'

class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :force => true do |t|
      t.column :email,                     :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :open_id_url,               :string
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime
      t.column :password_reset_code,       :string, :limit => 40
      t.column :password_reset_at,         :datetime
      t.column :active,                    :boolean, :default => true
      t.column :admin,                     :boolean, :default => false
      t.column :deleted_at,                :timestamp
      t.timestamps
    end
    add_index :users, :email
    add_index :users, :open_id_url

    create_table :open_id_associations, :force => true do |t|
      t.column :server_url,   :binary
      t.column :handle,       :string
      t.column :secret,       :binary
      t.column :issued,       :integer
      t.column :lifetime,     :integer
      t.column :assoc_type,   :string
    end

    create_table :open_id_nonces, :force => true do |t|
      t.column :nonce,        :string
      t.column :created,      :integer
    end

    create_table :open_id_settings, :force => true do |t|
      t.column :setting,      :string
      t.column :value,        :binary
    end
  end

  def self.down
    drop_table :users
    drop_table :open_id_associations
    drop_table :open_id_nonces
    drop_table :open_id_settings
  end

end
