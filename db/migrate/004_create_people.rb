class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people, :force => true,
      :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :personable_id,    :integer
      t.column :personable_type,  :string
      t.column :first_name,       :string
      t.column :last_name,        :string
      t.column :email,            :string
      t.column :user_id,          :integer

      t.timestamps
    end
    add_index :people, [:personable_id, :personable_type]
  end

  def self.down
    drop_table :people
  end
end
