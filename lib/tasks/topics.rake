require 'rubygems'
require 'faster_csv'

namespace :ubexact do
  namespace :topics do
  
    desc "Load CSV topic data"
    task :load => :environment do

      def setup_topics(topic0, topic1, topic2)
        topic = nil
        begin
          @t0 = Topic.find(:first, :conditions => ['name = ? and parent_id is null', topic0])
          if @t0.nil?
            @t0 = Topic.create(:name => topic0)
            @t0.update_attribute(:root_id, @t0.id)
          end

          @t1 = Topic.find_by_name_and_parent_id(topic1, @t0.id)
          if @t1.nil?
            @t1 = Topic.create(:name => topic1, :root_id => @t0.id)
            @t1.move_to_child_of @t0
            @t1.save
            # puts " === added #{@t1.name} TO #{@t0.name}"
          end

          @t2 = Topic.find_by_name_and_parent_id(topic2, @t1.id)
          if @t2.nil?
            @t2 = Topic.create(:name => topic2, :root_id => @t0.id)
            @t2.move_to_child_of @t1
            @t2.save
            # puts " === added #{@t2.name} TO #{@t1.name}"
          end

          topic = @t2
        rescue
          puts "Problem (#{topic0}; #{topic1}; #{topic2}): #{$!}"
        end
      end

      def import_csv(filename)
        maxrow = `wc -l #{filename}`.to_f
        row = 0
        puts "Loading sites from #{filename}"
        FasterCSV.foreach(filename,
          :headers => [:keyword1, :keyword2, :keyword3, :keyword4, :keyword5, :keyword6,
                       :keyword7, :keyword8, :ptopic, :stopic, :name, :url, :state,
                       :city, :free, :register, :activity, :description, :msa, :category,
                       :official, :pref1, :pref2, :pref3, :navads ]) do |line|

            if row > 1 && !line[:name].nil?
              printf "\r%5.2d %%  %5d  %-50s  ", (row/maxrow) * 100, row, line[:name][0,50]
              
              begin
                url = line[:url].strip.chomp("/")                
                unless url.include?("https://")    
                  url = url.gsub(/^(http:\/\/)?/, "http://") 
                end
                
                unless url.blank?
                  site = Site.find_by_url(url)
                  unless site.nil?
                    site.topic = setup_topics(line[:category], line[:ptopic], line[:stopic])
                  else
                    puts "URL is missing: #{line[:url]}"
                  end
                  site.save
                end
              rescue
                print "ERROR: ", $!, "\n"
              end
            end
            row += 1
        end
        printf "\r%s %-80s\n", "done.", "#{maxrow.to_i} loaded."
        
      end
    
      ['topics'].each do |table|
        ActiveRecord::Base.connection.execute("delete from #{table}")
      end
      Dir["#{RAILS_ROOT}/data/sites*.csv"].each do |csvfile|
        import_csv(csvfile)
      end
    
    end
  
  end
end
