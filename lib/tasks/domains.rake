require 'rubygems'
require 'faster_csv'

namespace :ubexact do
  namespace :domains do
    
    desc "Reconnect broken domain associations"
    task :refresh => :environment do
      puts "Loading domains"
      msaDomains = Hash.new
      domains = Hash.new
      Domain.find(:all).each do |d|
        if d.url =~ /ubexact(\w+)msa\./
          msaDomains[d.link_name] = d.id
        else
          domains[d.link_name] = d.id
        end
      end
      
      puts "Linking MSAs"
      MetroServiceArea.find(:all, :conditions => 'domain_id is null or domain_id = 1').each do |msa|        
        id = msaDomains[msa.link_name]
        unless id.nil?
          puts "  #{msa.name} => #{id}"
          msa.domain_id = id
          msa.save
        end
      end

      puts "Linking topics"
      Topic.find(:all, :conditions => 'domain_id is null and parent_id is null').each do |t|
        id = domains[t.link_name]
        unless id.nil?
          puts "  #{t.name} => #{domains[t.link_name]}" 
          t.domain_id = id
          t.save
        end
      end
      
      puts "Linking key phrases"
      KeyPhrase.find(:all, :conditions => 'domain_id is null').each do |p|
        id = domains[p.link_name]
        unless id.nil?
          puts "  #{p.phrase} => #{domains[p.link_name]}" 
          p.domain_id = id
          p.save
        end
      end

    end
  
    desc "Load CSV domain data"
    task :load => :environment do

      ActiveRecord::Base.connection.execute("delete from domains")
      %w(topics key_phrases metro_service_areas).each do |table|
        ActiveRecord::Base.connection.execute("update #{table} set domain_id = null")
      end
      filename = "#{RAILS_ROOT}/data/domains.csv"
      maxrow = `wc -l #{filename}`.to_f
      row = 0
      puts "Loading domains from #{filename}"

      FasterCSV.foreach(filename, :headers => [:url, :phrase]) do |line|

          url = line[:url]
          phrase = line[:phrase].split(/\s/).reject{|w| w == "ubexact" || w == "msa" }.join(" ")
          link_name = phrase.tr("^[A-Za-z0-9]", "").downcase
        
          printf "\r%5.2d %%  %5d  %-30s  ", (row/maxrow) * 100, row, link_name[0,30]
        
          domain = Domain.find_by_link_name(link_name)
          if domain.nil?
            domain = Domain.create :url => url, :phrase => phrase, :link_name => link_name
          end
        
          # [Topic KeyPhrase MetroServiceArea].each do |model|
          #   model.find_by_link_name(link_name).each do |m|
          #     m.domain_id = domain.id
          #     m.save
          #   end
          # end
        
          if domain.msa?
            MetroServiceArea.find_all_by_link_name(link_name).each do |msa|
              msa.domain_id = domain.id
              msa.save
            end
          else
            Topic.find_all_by_link_name(link_name).each do |t|
              t.domain_id = domain.id
              t.save
            end
        
            KeyPhrase.find_all_by_link_name(link_name).each do |p|
              p.domain_id = domain.id
              p.save
            end
          end

          # puts "#{url}  #{phrase}"
      end
      printf "\r%s %-80s\n", "done.", "#{maxrow.to_i} loaded."
              
    end
  end
end