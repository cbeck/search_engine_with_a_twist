require 'rubygems'
#require 'web_crawl'

namespace :ubexact do
  namespace :cache do

    def cache_clear
      puts "Clearing memcache of all entries..."
      # ActionController::Base.cache_store.clear
      CACHE.flush_all
      puts "done."
    end

    def cache_prime_topics
      puts "Priming topic cache..."
      ct = Topic.count
      idx = 0
      Topic.find(:all, :include => [:domain]).each do |topic|
        # topic.sub_topics
        # topic.under_topics
        topic.all_sites
        idx += 1
        printf "\r%5.2d \%", (idx.to_f/ct) * 100
      end
      printf "\r%s %-50s\n", "done.", "#{ct} loaded."
    end
    
    def cache_prime_cat_pages
      puts "Priming category page cache..."
            
      @categories = Topic.find :all, :include => [:domain],
          :conditions => ['parent_id is null and name is not null']
      ct = @categories.size
      idx = 0
      @categories.each do |cat|
        idx += 1
        printf "\r%5.2d %%  %-50s", (idx.to_f/ct) * 100, cat.name
      end
      printf "\r%s %-50s\n", "done.", "#{ct} loaded."      
    end
    
    def cache_prime_msa_pages
      puts "Priming msa page cache..."
      @msas = MetroServiceArea.find :all, :include => [:domain], 
        :conditions => ['homepage is not null'], :order => 'homepage'
      ct = @msas.size
      idx = 0
      @msas.each do |msa|    
        idx += 1
        printf "\r%5.2d %%  %-50s", (idx.to_f/ct) * 100, msa.name
      end
      printf "\r%s %-50s\n", "done.", "#{ct} loaded."      
    end
    
    desc "Clear memcache"
    task :clear => :environment do
      cache_clear
    end
  
    desc "Prime topic cache"
    task :prime_topics => :environment do
      cache_prime_topics
    end
    
    desc "Prime category page cache"
    task :prime_cat_pages => :environment do
      cache_prime_cat_pages
    end
    
    desc "Prime msa page cache"
    task :prime_msa_pages => :environment do
      cache_prime_msa_pages
    end

    desc "Reset cache"
    task :reset => :environment do
      cache_clear
      cache_prime_cat_pages
      cache_prime_msa_pages
      cache_prime_topics
    end

  end
end
