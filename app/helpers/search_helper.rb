module SearchHelper
  def filter_class(activity)
    (!@search.nil? && @search.activity == activity) ? 'selected-filter' : 'filter'
  end

  def topic_uri(topic, search)
    domain_topic_link = search.domain_topic.link_name unless search.domain_topic.nil?
    topic_links = search.topic_links.reject{|l| l == domain_topic_link }
    
    if search.term.blank? || search.default_term?
      if search.msa_link.nil?
        case topic_links.size
        when 2
          topic_url(topic_links[0], topic_links[1], 
            topic.link_name, :host => search.host)
        when 1
          topic_url(topic_links[0], topic.link_name, nil, :host => search.host)
        else
          topic_url(topic.link_name, nil, nil, :host => search.host)
        end
      else
        msa_topic_url(search.msa_link, topic.link_name, :host => search.host)
      end
    else
      if search.msa_link.nil? || search.domain_msa
        case topic_links.size
        when 2
          search_topic_url(CGI::escape(search.term), topic_links[0], topic_links[1], 
            topic.link_name, :host => search.host)
        when 1
          search_topic_url(CGI::escape(search.term), topic_links[0], 
            topic.link_name, nil, :host => search.host)
        else
          search_topic_url(CGI::escape(search.term), 
            topic.link_name, nil, nil, :host => search.host)
        end
      else
        search_msa_url(CGI::escape(search.term), search.msa_link, :host => search.host)
      end
    end
  end
  
  def msa_domain_url(msa)
    (msa.domain.nil?) ? MY_HOST : msa.domain.url
  end
  
  def msa_uri(msa, search)
    if search.term.blank? || search.default_term?
      if search.topic_links.empty?
        msa.domain.nil? ? msa_path(:msa => msa.link_name) : {:host => msa.domain.url}
      else
        msa_topic_url(msa.link_name, search.topic_links[0], :host => msa_domain_url(msa))
      end
    else
      if search.topic_link.blank?
        search_msa_url(CGI::escape(search.term), msa.link_name, :host => msa_domain_url(msa))
      else
        search_msa_topic_url(CGI::escape(search.term), msa.link_name, search.topic_link, :host => msa_domain_url(msa))
      end
    end
  end
  
  def keyphrase_uri(key_phrase, search)    
    domain = key_phrase.domain
    
    if search.msa_link
      (search.domain_msa.nil? || (search.domain_msa != search.msa_link)) ? search_msa_path(CGI::escape(key_phrase.name), search.msa_link) : search_term_path(CGI::escape(key_phrase.name))    
    elsif domain.nil? || RAILS_ENV == "development"
      search_term_url(CGI::escape(key_phrase.name), :host => MY_HOST)
    else
      {:host => domain.url}
    end
  end
    
  def category_uri(topic, search)
    if topic.domain.nil? || search.domain_msa || RAILS_ENV == 'development'
      category_url(topic.link_name, :host => search.host)
    else
      {:host => topic.domain.url}
    end
  end
  
  def msa_uri(msa, search, use_path=false)
    if msa.domain.nil? || use_path
      msa_url(msa.link_name, :host => ((search.host =~ /msa\./) ? MY_HOST : search.host))
    elsif RAILS_ENV == "development"
      msa_url(msa.link_name, :host => MY_HOST)
    else
      {:host => msa.domain.url}
    end
  end

  def search_context
    topics = @search.topic_links.collect{|link_name| 
      topic = Topic.find_by_link_name(link_name)
      link_to topic.name, topic_url(topic.link_name, nil, nil, :host => @search.host)
    }
    topics.join " > "
  end

  def render_popular_categories(categories, search)
    ret = ""
    ret += '<ul class="pop-cat-list">'
    count = 0
    column = 1
    for topic in categories
		  ret +=	"<li>#{link_to topic.name, category_uri(topic, search)}</li>"
		  count += 1
		  if count == (categories.size/3).to_int
		    ret += "</ul>"
		    ret += '<ul class="pop-cat-list">'
		    column += 1
		    count = 0 unless column == 3
	    end
	  end
		ret += "</ul>"
	end
	
	def render_msa_links(msas, search)
	  ret = ""
	  ret += '<ol class="msa-top-links">'
	  count = 0
	  column = 1
	  for msa in msas.sort_by{|m| m.name}
		  ret += 	"<li>#{link_to msa.name, msa_uri(msa, search)}</li>"
		  count += 1
		  if count == (msas.size/3).to_int
		    ret += "</ol>"
		    ret += '<ol class="msa-top-links">'
		    column += 1
		    count = 0 unless column == 3
	    end
	  end
		ret += "</ol>"
  end
end
