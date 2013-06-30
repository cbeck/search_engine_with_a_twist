class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states, :force => true do |t|
      t.string :code, :limit => 2
      t.string :name, :limit => 35
    end
    add_index :states, :code
    
    State.create(:code => 'AL', :name => 'Alabama')
    State.create(:code => 'AK', :name => 'Alaska')
    State.create(:code => 'AZ', :name => 'Arizona')
    State.create(:code => 'AR', :name => 'Arkansas')
    State.create(:code => 'CA', :name => 'California')
    State.create(:code => 'CO', :name => 'Colorado')
    State.create(:code => 'CT', :name => 'Connecticut')
    State.create(:code => 'DE', :name => 'Delaware')
    State.create(:code => 'DC', :name => 'District of Columbia')
    State.create(:code => 'FL', :name => 'Florida')
    State.create(:code => 'GA', :name => 'Georgia')
    State.create(:code => 'HI', :name => 'Hawaii')
    State.create(:code => 'ID', :name => 'Idaho')
    State.create(:code => 'IL', :name => 'Illinois')
    State.create(:code => 'IN', :name => 'Indiana')
    State.create(:code => 'IA', :name => 'Iowa')
    State.create(:code => 'KS', :name => 'Kansas')
    State.create(:code => 'KY', :name => 'Kentucky')
    State.create(:code => 'LA', :name => 'Louisiana')
    State.create(:code => 'ME', :name => 'Maine')
    State.create(:code => 'MD', :name => 'Maryland')
    State.create(:code => 'MA', :name => 'Massachusetts')
    State.create(:code => 'MI', :name => 'Michigan')
    State.create(:code => 'MN', :name => 'Minnesota')
    State.create(:code => 'MS', :name => 'Mississippi')
    State.create(:code => 'MO', :name => 'Missouri')
    State.create(:code => 'MT', :name => 'Montana')
    State.create(:code => 'NE', :name => 'Nebraska')
    State.create(:code => 'NV', :name => 'Nevada')
    State.create(:code => 'NH', :name => 'New Hampshire')
    State.create(:code => 'NJ', :name => 'New Jersey')
    State.create(:code => 'NM', :name => 'New Mexico')
    State.create(:code => 'NY', :name => 'New York')
    State.create(:code => 'NC', :name => 'North Carolina')
    State.create(:code => 'ND', :name => 'North Dakota')
    State.create(:code => 'OH', :name => 'Ohio')
    State.create(:code => 'OK', :name => 'Oklahoma')
    State.create(:code => 'OR', :name => 'Oregon')
    State.create(:code => 'PA', :name => 'Pennsylvania')
    State.create(:code => 'RI', :name => 'Rhode Island')
    State.create(:code => 'SC', :name => 'South Carolina')
    State.create(:code => 'SD', :name => 'South Dakota')
    State.create(:code => 'TN', :name => 'Tennessee')
    State.create(:code => 'TX', :name => 'Texas')
    State.create(:code => 'UT', :name => 'Utah')
    State.create(:code => 'VT', :name => 'Vermont')
    State.create(:code => 'VA', :name => 'Virginia')
    State.create(:code => 'WA', :name => 'Washington')
    State.create(:code => 'WV', :name => 'West Virginia')
    State.create(:code => 'WI', :name => 'Wisconsin')
    State.create(:code => 'WY', :name => 'Wyoming')
  end

  def self.down
    drop_table :states
  end
end
