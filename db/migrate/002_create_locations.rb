class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :addressable_id,   :integer
      t.column :addressable_type, :string
      t.column :address_line1,    :string
      t.column :address_line2,    :string
      t.column :city,             :string
      t.column :state,            :string, :limit => 2
      t.column :postal_code,      :string
      t.column :country,          :string
      t.column :directions,       :string
      t.column :longitude,        :float
      t.column :latitude,         :float

      t.timestamps      
    end
    add_index :locations, [:addressable_id, :addressable_type]
    
  end

  def self.down
    drop_table :locations
  end
end
