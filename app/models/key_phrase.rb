class KeyPhrase < ActiveRecord::Base
  belongs_to :site
  belongs_to :domain
  before_save :create_link_name, :assign_domain
  
  def words
    (phrase.blank?) ? 0 : phrase.split(/\s/).size
  end
  
  def name
    self.phrase
  end
  
  def hash
    name.hash
  end
  
  def eql?(other)
    name == other.name
  end
  
  def <=>(other)
    name.downcase <=> other.name.downcase
  end
  
  protected
  def create_link_name
    self.link_name = phrase.sub('&', 'and').tr("^[A-Za-z]", "").downcase
  end
  
  def assign_domain
    domain = Domain.find_by_link_name(self.link_name)
    self.domain = domain unless domain.nil?
  end
  
end
