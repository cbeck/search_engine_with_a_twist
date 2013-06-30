require 'rubygems'
require 'faster_csv'

namespace :ubexact do
  namespace :msa_links do
  
    desc "Load CSV msa link data"
    task :load => :environment do
    
      def scrub_link_name(long_link_name)
        no_ub = long_link_name.strip.sub('ubexact', '')
        no_ub.sub('msa.com', '')
      end
    
      def get_parent_link_name(parent_name)
        parent_name.strip.sub('_', '')
      end

      def import_csv(filename)
        maxrow = `wc -l #{filename}`.to_f
        row = 0
        puts "Loading msa links from #{filename}"        
        
        FasterCSV.foreach(filename,
          :headers => [:link_name, :url, :name, :flash_filename, :parent]) do |line|
            if row > 0
              unless line[:link_name].blank?
                printf "\r%5.2d %%  %5d  %-30s  ", (row/maxrow) * 100, row, line[:link_name][0,30]
                
                link_name = scrub_link_name line[:link_name]
                msa = MetroServiceArea.find_by_link_name(link_name) unless link_name.blank?           
                if msa.nil?
                  #Rely on domain to tell us what this is
                  domain = Domain.find_by_link_name(link_name)
                  unless domain.nil?
                    msa = MetroServiceArea.create :name => domain.phrase.titleize, :link_name => link_name, :flash_filename => line[:flash_filename], :domain_id => domain
                  end
                end
                if  msa.nil? || line[:name].blank? || line[:url].blank?
                  puts "MSA Link Not Added"
                    # : #{link_name} -- #{line[:name]} | #{line[:link_name]} | #{line[:url]}"
                else
                  msa.metro_service_area_links.create(:name => line[:name], :url => line[:url])
                  msa.flash_filename ||= line[:flash_filename]
                  unless line[:parent].blank?
                    parent_msa = MetroServiceArea.find_by_link_name(get_parent_link_name(line[:parent]))
                    msa.parent ||= parent_msa
                  end 
                  msa.save
                end
              end
            end          
            row += 1
        end
        printf "\r%s %-80s\n", "done.", "#{maxrow.to_i} loaded."
        
      end
    
      ['metro_service_area_links'].each do |table|
        ActiveRecord::Base.connection.execute("delete from #{table}")
      end
      Dir["#{RAILS_ROOT}/data/msa_links*.csv"].each do |csvfile|
        import_csv(csvfile)
      end
    
    end
  
  end
end