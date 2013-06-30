class Search   #< ActiveRecord::Base
  attr_accessor :term, :sites, :total, :page, :per_page, :activity, :category, :topics,
    :metro_service_areas, :preferred_links, :topic_links, :msa, :msa_link, :topic_link, :host, 
    :msa_sub_areas, :domain_msa, :domain_topic, :domain_keyphrase, :domain_keyword, :domain_link
  
  DEFAULT_TERM = "enter search here"
  
  def initialize(options={}, host=MY_HOST)
    default_options = {
      :term => DEFAULT_TERM,
      :category => false,
      :per_page => 30, :page => 1, :msa => nil
    }
    options = default_options.merge options.symbolize_keys
    
    self.host = host
    self.sites = []
    self.term = CGI::unescape(options[:term]) unless options[:term].nil?
    self.term = "" if default_term?
    self.activity = options[:activity]
    self.per_page = options[:per_page]
    self.category = options[:category]
    self.page = options[:page]
    
    self.domain_msa = $1.downcase if (host =~ /ubexact(\w+)msa\./)
    self.msa_link =  options[:msa] || self.domain_msa
    
    if self.domain_msa.nil? && (host =~ /ubexact(\w+)\./)
      self.domain_link = $1.tr("^[A-Za-z0-9]", "").downcase
      
      unless self.domain_link.nil?
        self.domain_topic = Topic.find :first, :include => [:domain],
            :conditions => ['link_name = ? and parent_id is null and name is not null', self.domain_link]
        
        if self.domain_topic.nil?
          self.domain_keyphrase = KeyPhrase.find(:first, :conditions=>['link_name=?',self.domain_link])
          if self.domain_keyphrase.nil?
            self.domain_keyword = self.domain_link
          end
        end
      end
    end

    domain_topic_link = self.domain_topic.link_name unless self.domain_topic.nil?
    self.topic_links = [
      domain_topic_link, options[:topic1], options[:topic2], options[:topic3]
    ].reject{|t| t.nil?}
    self.topic_link = self.topic_links.join '/'

  end
  
  def domain_alt
    return @domain_alt unless @domain_alt.nil?
    unless ["development", "test"].include? RAILS_ENV
      if term && !domain_query? && self.topic_links.blank? && self.msa_link.nil?
        domain = Domain.find(:first, :conditions => ['link_name=?',term.tr("^[A-Za-z0-9]", "").downcase])
        @domain_alt = "http://#{domain.url}" unless domain.nil? || domain.url.nil?
      end
    end
  end
  
  def default_term?
    @term == DEFAULT_TERM
  end
    
  def domain_query?
    @domain_msa || @domain_topic || @domain_keyphrase || @domain_keyword
  end 

  def name
    label = []
    label << MetroServiceArea.find_by_link_name(@msa_link).name unless @msa_link.nil?
    label << @term unless (@term.blank? || default_term?)
    label << @topic_links.collect {|t| 
      topic = Topic.find_by_link_name(t)
      (topic.nil?) ? t : topic.name
    }
    label.flatten.join(' > ')
  end
  
  def execute
    term_sites =  find_by_term
    topic_sites = find_by_topic
    msa_sites = find_by_msa
        
    sites = [term_sites, topic_sites, msa_sites].reject{|s| s.nil?}.inject{|sites, s| sites & s}
    @sites = (sites.blank?) ? [] : priority_sort(sites.flatten)
    
    # *****
    # limiting result set to 100 sites.  Need to paginate
    # @sites = @sites[0..100]
  end
  
  def priority_sort(sites)
    unless sites.nil?
      priority_sites = find_by_key_phrase
      unless priority_sites.nil?
        sites.partition {|site| priority_sites.include?(site) }.flatten
      else
        sites
      end
    end
  end
  
  def related_topics
    unless @sites.blank?
      if @related_topics.nil?
        arr = @sites.collect{|s| 
          s.related_topics
        }
        @related_topics = arr.flatten.uniq.sort
      end
      @related_topics
    end
  end
  
  def sub_topics
    site_topics = @sites.collect {|s| s.topic.sub_topics unless s.topic.nil? }.flatten
    site_topics = site_topics.reject{|t| t.nil? || t.link_name.blank? || @topic_links.include?(t.link_name) }

    unless @topics.blank?
      topic_children = @topics.collect{|t| t.under_topics }.flatten
      site_topics = site_topics.find_all{|t| topic_children.include?(t)}
    end
    site_topics.sort.uniq
  end
  
  # TODO: preferred? should take topic
  def preferred_links
    domain_phrase = @domain_keyphrase.phrase unless @domain_keyphrase.nil?
    link_names = [domain_phrase, @domain_keyword, @term, @topic_links].flatten.reject{|q|q.blank?}
    link_names = link_names.collect{|n| n.tr("^[A-Za-z0-9]", "").downcase}
    
    if link_names.empty? and !@sites.blank?
      ids = @sites.collect{|s| s.id}
      @preferred_links ||=
        KeyPhrase.find(:all, :conditions => ['site_id in (?) and preferred = ?', ids, true],
          :order => "paid DESC" , :include => :site)
    elsif !link_names.empty?
      @preferred_links ||= 
        KeyPhrase.find(:all, :conditions => ["preferred = ? and link_name in (?)", true, link_names], 
          :order => "paid DESC" , :include => :site)
    end
    @preferred_links.select {|pl|
      case pl.ad_context
        when "state" : true unless @msa_link.nil?
        when "msa" : true if msa_preferred_link?(pl)
        else true
      end
    } unless @preferred_links.empty?
  end
  
  def msa_preferred_link?(pref_link)
    pass = false
    unless @msa_link.nil? || pref_link.site.nil? || pref_link.site.metro_service_area.nil?
      #[@msa_link, "online"].include?(pref_link.site.metro_service_area.link_name)
      pass = pref_link.site.metro_service_area.link_name == @msa_link 
      unless pass || pref_link.site.city.nil?
        pass = pref_link.site.city.tr("^[A-Za-z0-9]", "").downcase == @msa_link
      end
    end
    pass    
  end
  
  def pages_for(options = {})
    default_options = {:per_page => 30, :page => 1}
    options = default_options.merge options
    pages = Paginator.new self, total, options[:per_page], options[:page]
    return pages
  end
  
  def total_pages
    self.sites.size / self.per_page
  end
  
  protected
  def find_by_term
    domain_phrase = @domain_keyphrase.phrase unless @domain_keyphrase.nil?
    query = [domain_phrase, @domain_keyword, @term].reject{|q|q.blank?}.join(' ')
    unless (query.blank? || default_term?)
      Site.full_text_search(query).reject {|s| s.disabled?} unless query.blank?
    end
  end
  
  def find_by_key_phrase
    domain_phrase = @domain_keyphrase.phrase unless @domain_keyphrase.nil?
    query = [domain_phrase, @domain_keyword, @term].reject{|q|q.blank?}.join(' ')
    unless (query.blank? || default_term?)
      phrase = query.tr("^[A-Za-z0-9]", "").downcase
      kps = KeyPhrase.find(:all, :conditions => ['link_name = ?', phrase], :include => 'site')
      sites = kps.collect{|k| k.site}.reject{|s| s.nil? || s.disabled?}
    end
  end
  
  def find_by_topic
    links = @topic_links.reject{|l|l.nil?}.reverse
    return nil if links.empty?
    @topics = Topic.find(:all, :conditions => ['link_name = ?', links.shift],
      :include => [{:sites => :key_phrases}, :domain])
    
    unless @topics.blank? || links.empty?
      # ensure all remaining topic_links in ancestor chain
      @topics = @topics.find_all {|t| 
        links.find_all {|l| 
          t.sub_topics.detect {|a| a.link_name == l }
        }.size == links.size 
      }
    end
    
    # collect all sites related to these topics
    sites = @topics.collect{|t| t.all_sites}.flatten.uniq
  end
  
  def find_by_msa
    unless @msa_link.nil?
      if @msa_link == "other"
        self.msa = nil
        msas = MetroServiceArea.find(:all, 
          :conditions => "homepage is null and parent_id is null and flash_filename is null",
          :include => [:domain])
        sites = msas.collect{|m| m.sites}
      # elsif @msa_link == "online"
      #   sites = Site.all_online
      else
        # we went through this logic already - msa_link is set to correct value
        msas = MetroServiceArea.find(:all, 
          :conditions => ['link_name = ?', @msa_link], :include => [:domain])
        unless msas.blank?
          self.msa = msas.first
          @metro_service_areas = self.msa.metro_service_area_links
          @msa_sub_areas = self.msa.children.sort_by{|mc| mc.name}
          sites = msas.collect{|m| m.sites}
          all_msa_sites = Site.find_all_by_all_msas(true)
          sites += all_msa_sites
        end
      end
      sites.flatten unless sites.blank?
    end
  end
  
end