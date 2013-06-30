class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :user_id
      t.integer :discount_id
      t.integer :amount
      t.integer :payment_type_id

      t.timestamps
    end
    
    add_index :payments, :user_id
  end

  def self.down
    drop_table :payments
  end
end
