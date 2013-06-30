class History
  attr_accessor :requests, :key
  
  def History.find(key)
    History.new(key)
  end

  def History.destroy_all
    CACHE.flush_all
  end
  
  def save
    unless CACHE.get(@key).nil?
      # puts "SETTING hist #{@key} with #{@requests.size} items"
      CACHE.set @key, @requests, 2.hours
    else
      # puts "ADDING hist #{@key} with #{@requests.size} items"
      CACHE.add @key, @requests, 2.hours
    end
  end

  def destroy
    CACHE.delete @key
  end

  def add(url, name)
    @requests << {:url => url, :name => name}
  end

  def visited?(url)
    !@requests.detect{|h| h[:url] == url}.nil?
  end

  def last_url?(url)
    !@requests.empty? && @requests.last[:url] == url
  end
  
protected
  def initialize(key)
    @key = key
    @requests = CACHE.get(@key) || []
    # puts "using initilizer (#{@requests.size})"
  end
  
end