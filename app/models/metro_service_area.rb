class MetroServiceArea < ActiveRecord::Base
  # acts_as_ferret :fields => [:name]
  is_indexed :fields => ['name']
  
  before_save :create_link_name
  # has_many :sites, :dependent => :nullify, :conditions  => ['disabled IS NULL or disabled = ?', false],
  #     :include => [
  #       {:metro_service_area => :domain}, 
  #       {:key_phrases => :domain}, 
  #       {:related_topics => :domain},
  #       :topic
  #     ]

  has_many :metro_service_area_links, :dependent => :destroy
  belongs_to :domain
  
  acts_as_tree
  
  def hash
    name.hash
  end
  
  def eql?(other)
    name == other.name
  end
  
  def <=>(other)
    name.downcase <=> other.name.downcase
  end
  
  def short_url
    "ubexact" + link_name.gsub(/_/, '') + "msa.com"
  end
  
  def url
    "http://www." + short_url
  end
  
  def sites
    child_ids = (!self.children.empty?) ?  self.children.collect{|msa| "," + msa.id.to_s}.to_s : ""
    conditions = "(disabled IS NULL or disabled = 0) and metro_service_area_id in (#{self.id}" + child_ids + ")"
    Site.find(:all, :conditions => conditions, :include => [
      {:metro_service_area => :domain}, 
      {:key_phrases => :domain}, 
      {:related_topics => :domain},
      :topic
    ])
  end 
  
  # def sites(location, online_only = false)
  #   sites = []
  #   online_sites = []
  #   
  #   unless online_only
  #     child_ids = (!self.children.empty?) ?  self.children.collect{|msa| "," + msa.id.to_s}.to_s : ""
  #     conditions = "metro_service_area_id in (#{self.id}" + child_ids + ")"
  #     sites = Site.find(:all, :conditions => conditions)
  #   end
  #   
  #   online_msa = MetroServiceArea.find_by_name("Online")
  #   unless ["online", "other"].include?(location)
  #     msa = MetroServiceArea.find_by_link_name(location)
  #     unless msa.nil?
  #       if msa.parent
  #         state = State.find_by_link_name(msa.parent.link_name)
  #         unless state.nil?
  #           online_sites = Site.find(:all, 
  #             ["metro_service_area_id=? and city=? and state=?", online_msa.id, msa.name, state.code])
  #         end
  #       else
  #         state = State.find_by_link_name(msa.link_name)
  #         unless state.nil?
  #           online_sites = Site.find(:all, 
  #             ["metro_service_area_id=? and state=?", online_msa.id, state.code])
  #         end
  #       end
  #     else
  #       online_sites = Site.find(:all, ["metro_service_area_id=?", online_msa.id]) if online_sites.blank?
  #     end      
  #   end
  #   sites + online_sites
  # end

  protected
  def create_link_name
    self.link_name = name.tr("^[A-Za-z]", "").downcase
  end
  
end
