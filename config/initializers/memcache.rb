require 'memcache'
MEMCACHE_OPTIONS = {
   :compression => false,
   :debug => false,
   :namespace => "ubexact-#{RAILS_ENV}",
   :readonly => false,
   :urlencode => false
}
# MEMCACHE_SERVERS = [ '127.0.0.1:11211' ]

cache_params = *([MEMCACHE_SERVERS, MEMCACHE_OPTIONS].flatten)
CACHE = MemCache.new *cache_params
ActionController::CgiRequest::DEFAULT_SESSION_OPTIONS.merge!({ 'cache' => CACHE })
