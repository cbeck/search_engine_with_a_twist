class Activity < ActiveRecord::Base
  has_many :sites
  acts_as_enumerated :order => 'position ASC'
end
