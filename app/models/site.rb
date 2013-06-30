class Site < ActiveRecord::Base
  has_many :key_phrases
  has_many :related_topics, :class_name => "KeyPhrase", 
    :conditions => ["key_phrases.linkable = ? and key_phrases.preferred = ?", true, false]
  belongs_to :topic

  # belongs_to :activity
  belongs_to :metro_service_area
  belongs_to :user
  has_enumerated :activity
  
  validates_presence_of :activity_id, :if => Proc.new { |s| !s.disabled? } 
  validates_presence_of :topic_id, :if => Proc.new { |s| !s.disabled? }
  
  acts_as_commentable
  
  # acts_as_ferret :fields => [:name, :key_phrase_names, :topic_names, :state, :city]
  
  is_indexed :conditions => "disabled = 0 or disabled is null",
      :fields => [
        {:field => 'name', :as => 'name'},
        {:field => 'state', :as => 'state'},
        {:field => 'city', :as => 'city'}
      ],
      :concatenate => [
        {:class_name => 'Topic', :field => 'name', :association_sql => 
            "LEFT OUTER JOIN topics topic on sites.topic_id = topic.id LEFT OUTER JOIN topics t2 on t2.root_id = topic.root_id and (topic.lft between t2.lft and t2.rgt)",
            :as => 'topic_names'
        },
        {:association_name => 'key_phrases', :field => 'phrase', :as => 'key_phrase_names'}
      ]
      # :delta => true  
   
  
  # def sub_topics
  #   self.topic.self_and_ancestors unless s.topic.nil?
  # end
  
  def topic_names
    if topic.blank?
      {}
    else
      @topic_names ||= topic.sub_topics.collect { |t| t.name }.join(' ')
    end
  end
  
  def self.all_online
    Site.find(:all, :conditions => ["online = ? and disabled IS NULL or disabled = ?", true, false], :include => [
      {:metro_service_area => :domain}, 
      {:key_phrases => :domain}, 
      {:related_topics => :domain},
      :topic
    ])
  end
  
  # def link_names
  #   @link_names = topic.self_and_ancestors.collect { |t| t.link_name } unless topic.nil?
  #   @link_names << metro_service_area.link_name unless metro_service_area.nil?
  #   @link_names.join(' ')
  # end
  
  # def key_phrase_names
  #   key_phrases.collect {|p| p.phrase }.join(' ')
  # end
  
  def preferred?(term)
    !key_phrases.detect{|kp| kp.preferred? && term =~ /#{kp.phrase}/i  }.nil?
  end
  
  def location
    loc = ""
    loc << city unless city.nil?
    loc << ", #{state} " unless state.nil? || ['ON'].include?(state)
    loc << " #{country_code}" unless country_code.nil? || ['US', 'Online', 'ON'].include?(country_code)
    (loc.blank?) ? "Online" : loc
  end
  
  def self.find_with_includes(id)
    find(id, :include => [
          {:metro_service_area => :domain}, 
          {:key_phrases => :domain}, 
          {:topic => :domain}, 
          {:related_topics => :domain}])
  end
  
  def self.full_text_search(q, options = {}, find_options = {})
    return nil if q.blank?
    # default_options = {:limit => 1000, :page => 1 }
    # default_find_options = {
    #   :include => [
    #     {:metro_service_area => :domain}, 
    #     {:key_phrases => :domain}, 
    #     {:topic => :domain}, 
    #     {:related_topics => :domain}]
    # }
    # 
    # options = default_options.merge options    
    # find_options = default_find_options.merge find_options
    # 
    # # get the offset based on what page we're on
    # options[:offset] = options[:limit] * (options.delete(:page).to_i-1)  
    # 
    # # now do the query with our options
    # results = Site.find_by_contents(q, options, find_options).reject {|s| s.disabled? }
    # # return [results.total_hits, results]
    
    search = Ultrasphinx::Search.new(:query => q, :class_names => 'Site', :per_page=>500)
    search.run
    search.results    
  end
  
  def short_url
    if url.length > 50
      "%-05.50s..." % url
    else
      url
    end
  end
  
  def build_key_phrases(attributes)
    self.key_phrases.destroy_all    
    unless attributes.blank?
      attributes.each { |kp| self.key_phrases.build(kp) unless kp[:phrase].blank? }
    end
  end
  
  def ordered_comments
    (self.comments.empty?) ? self.comments: self.comments.reverse
  end
  
  def hash
    url.hash
  end
  
  def eql?(other)
    !other.nil? && url == other.url
  end
  
  def <=>(other)
    url.downcase <=> other.url.downcase
  end
  
  def validate
    regulate_url
    blacklisted_site = BlacklistedSite.find_by_url(url)
    unless blacklisted_site.nil?
      errors.add(:url, "is not an acceptable URL for our system. If you feel this is an error, please contact us.") 
    end
    
    if duplicate_url?
      errors.add(:url, "has already been submitted to our system. If you feel this is an error, please contact us.")
    end
  end
  
  private
  
  def duplicate_url?
    dup = false
    if new_record?
      sponged_url = sponged_url(self.url)
      if Site.find_by_url("http://#{sponged_url}")
        return true
      elsif Site.find_by_url("http://www.#{sponged_url}")
        return true
      elsif Site.find_by_url("https://#{sponged_url}")
        return true
      elsif Site.find_by_url("https://www.#{sponged_url}")
        return true
      end
    end
    dup
  end
  
  def sponged_url(url)
    url = url.strip.chomp("/")
    spongy = url.gsub(/^(http:\/\/|https:\/\/)?(www\.)?/, "")
    spongy.gsub(/(\/home|\/default|\/frontpage|\/index\.html|\/store|\/main)?$/, "")
  end
  
  def regulate_url
    self.url = self.url.strip.chomp("/")
    self.url = self.url.gsub(/^(http:\/\/)?/, "http://") unless self.url.include?("https://")    
  end
end
