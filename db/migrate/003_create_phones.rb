class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :callable_id,    :integer
      t.column :callable_type,  :string
      t.column :number,         :string
      t.column :extension,      :string
      t.column :description,    :string
      t.column :phone_type,     :string
      t.column :main,        :boolean

      t.timestamps
    end
    add_index :phones, [:callable_id, :callable_type]
    
  end

  def self.down
    drop_table :phones
  end
end
