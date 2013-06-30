require 'rubygems'
require 'faster_csv'

namespace :ubexact do
  namespace :link_list do
  
    desc "Load CSV link list data (sites with just URLs)"
    task :load => :environment do

      def import_csv(filename)
        maxrow = `wc -l #{filename}`.to_f
        row = 0
        puts "Loading sites (url only) from #{filename}"

        FasterCSV.foreach(filename,
          :headers => [:url]) do |line|
            if row > 0
              begin
                unless line[:url].blank?
                  printf "\r%5.2d %%  %5d  %-40s  ", (row/maxrow) * 100, row, line[:url][0,40]
                  site = Site.new(:url => line[:url], :disabled => true)
                  # site.disable_ferret
                  site.save
                  # puts "#{row}: #{(site.id.nil?) ? 'Duplicate' : site.id} - #{site.url}"
                end
              rescue
                puts "Houston, we have a problem: #{line[:url]}"
              end
            end          
            row += 1
        end
        printf "\r%s %-80s\n", "done.", "#{maxrow.to_i} loaded."
        
      end
    
      Dir["#{RAILS_ROOT}/data/link_list*.csv"].each do |csvfile|
        import_csv(csvfile)
      end
    
    end
  
  end
end