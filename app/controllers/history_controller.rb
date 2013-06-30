class HistoryController < ApplicationController
  # protect_from_forgery :except => [:show]
  skip_before_filter :verify_authenticity_token

  def new
    session[:history_key] = nil
    show
  end
  
  def show
    @history = History.find cache_key
    unless params[:url].nil? || @history.last_url?(params[:url])
      @history.add(params[:url], name(params))
      @history.save
      # puts "saved history with #{@history.requests.size} items"
    end
    render :partial => 'history'
  end

  def destroy
    @history = History.find cache_key
    @history.destroy
    render :text => 'OK'
  end
  
protected
  
  def cache_key
    session[:history_key] ||= hex_key
    "history_#{request.remote_ip}_#{session[:history_key]}"
  end
  
  def hex_key
    n = (Time.now.to_i - 1212590613) * 1000000 + (rand*1000000).to_i
    n.to_s(16)
  end
  
  def name(h)
    arr = []
    unless h[:msa].blank?
      msa = MetroServiceArea.find_by_link_name(h[:msa])
      arr << ((msa.nil?) ? h[:msa].humanize : msa.name)
    end
    unless h[:topics].blank?
      h[:topics].each do |t|
        topic = Topic.find(:first, :conditions => ['link_name = ?', t])
        arr << ((topic.blank?) ? t.humanize : topic.name)
      end
    end
    unless h[:term].blank?
      arr << h[:term]
    end
    if arr.empty?
      h[:url] =~ /\/(demo\.)?([\w\.]+)/
      domain = Domain.find_by_url($2)
      arr << (domain.nil? ? $2 : domain.phrase)
    end

    arr.flatten.join(" > ")
  end
  
  def keyword(url)
    case url
    when /ubexact([^\.]+?)msa\./
      msa = MetroServiceArea.find_by_link_name($1)
      (msa.nil?) ? $1.humanize : msa.name
    when /ubexact([^\.]+?)\./
      topic = Topic.find_by_link_name($1)
      (topic.nil?) ? $1.humanize : topic.name
    when /category\/([a-z]+)$/
      topic = Topic.find_by_link_name($1)
      (topic.nil?) ? $1.humanize : topic.name
      $1.humanize
    when /topic\/.*(\w+)$/
      topic = Topic.find_by_link_name($1)
      (topic.nil?) ? $1.humanize : topic.name
      $1.humanize
    else
      url
    end
  end
end
