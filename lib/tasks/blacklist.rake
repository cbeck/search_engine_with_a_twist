require 'rubygems'
require 'faster_csv'

namespace :ubexact do
  namespace :blacklist do
  
    desc "Load CSV blacklist data"
    task :load => :environment do

      def import_csv(filename)
        maxrow = `wc -l #{filename}`.to_f
        row = 0
        puts "Loading blacklist from #{filename}"

        FasterCSV.foreach(filename,
          :headers => [:url]) do |line|
            if row > 0
              unless line[:url].blank?
                printf "\r%5.2d %%  %5d  %-40s  ", (row/maxrow) * 100, row, line[:url][0,40]
                
                BlacklistedSite.find_or_create_by_url(:url => line[:url])
              end
            end          
            row += 1
        end
        printf "\r%s %-80s\n", "done.", "#{maxrow.to_i} loaded."
        
      end

    
      ActiveRecord::Base.connection.execute("delete from blacklisted_sites")

      Dir["#{RAILS_ROOT}/data/blacklist*.csv"].each do |csvfile|
        import_csv(csvfile)
      end
    
    end
  
  end
end