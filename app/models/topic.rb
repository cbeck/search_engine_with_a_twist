require 'site'
require 'key_phrase'
require 'domain'
require 'metro_service_area'

class Topic < ActiveRecord::Base
  acts_as_nested_set :scope => :root_id
  belongs_to :parent, :class_name => 'Topic'
  belongs_to :domain
  has_many :sites, :conditions  => ['disabled IS NULL or disabled = ?', false],
    :include => [
      {:metro_service_area => :domain}, 
      {:key_phrases => :domain}, 
      {:related_topics => :domain},
      :topic
      ]
  has_many :key_phrases, :through => :sites
  before_save :create_link_name

  def skip_cache?
    ["development", "test"].include? RAILS_ENV
  end

  #### full_set include arg
  # {}, [
  #   {:sites => [
  #       {:key_phrases => :domain}, 
  #       {:metro_service_area => :domain}, 
  #       {:related_topics => :domain},
  #       {:topic => :domain}
  #   ]}
  # ]
  
  def all_sites
    unless skip_cache?
      ids = CACHE.get(all_sites_cache_key)
    end

    if ids.nil?
      # sites = full_set({}).collect {|t| t.sites }.flatten
      
      sites = full_set({},
        :sites => [
            {:key_phrases => :domain}, 
            {:metro_service_area => :domain}, 
            {:related_topics => :domain},
            {:topic => :domain}
        
      ]).collect {|t| t.sites }.flatten
      
      unless skip_cache?
        begin
          CACHE.add all_sites_cache_key, sites.collect{|s|s.id}
        rescue
          print "AllSites cache failed: ", $!, "\n"
        end
      end
    else
      sites = Site.find :all, :conditions => ["id in (?)", ids], 
        :include => [
          {:metro_service_area => :domain}, 
          {:key_phrases => :domain}, 
          {:related_topics => :domain},
          :topic
        ]
    end
    sites
  end
  
  def all_sites_cache_key
    @topicsite_cache_key ||= "#{id}-topicsites"
  end
    
  def sub_topics
    self_and_ancestors
  end
  
  # I hate these stupid terms I have to come up with because of W's ridiculous vocabulary
  def under_topics
    all_children
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
  
  def Topic.ordered_roots
    Topic.roots.sort {|a,b| a.name <=> b.name}
  end

  def Topic.find_related_topics_for_sites(sites, excl=[])
    topics = Topic.find(:all, 
                        :conditions => ['id in (?)', sites.collect{|s|s.topic_id}], 
                        :order => 'name')
    topics = topics.reject{|t| excl.include? t.link_name } unless topics.nil? || excl.empty?
    topics.uniq unless topics.nil?
  end
  
  def Topic.find_sub_topics_of_parent_ids(parent_ids, excl=[])
    topics = Topic.find(:all, 
                        :conditions => ['id in (?)', parent_ids], 
                        :order => 'name')
    topics = topics.reject{|t| excl.include?(t.link_name)} unless topics.nil? || excl.empty?
    topics.uniq unless topics.nil?
  end
  
  protected
  def create_link_name
    self.link_name = name.sub('&', 'and').tr("^[A-Za-z]", "").downcase
  end
  
end
