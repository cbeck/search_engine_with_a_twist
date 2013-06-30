require 'rubygems'
require 'faster_csv'

namespace :ubexact do
  namespace :sites do
  
    desc "Load CSV site data"
    task :load => :environment do
        
      def state_code(name)
        state = State.find_by_name(name)
        puts "Can't find state #{name}" if state.nil?
        state.code
      end

      def free?(code)
        case code
          when /Free/i
            true
          when /\$/
            false
          else
            puts "Free? #{code}"
        end
      end

      def register?(code)
        case code
        when /No/i
          false
        when /Yes/i
          true
        else
          puts "Register? #{code}"
        end
      end
    
      def parse_state(name)
        state = State.find_by_name(name)
        if state.nil?
          c = Country.find_by_name(name.upcase)
          if c.nil?
            country = name
          else
            country = c.code
          end
        else
          state = state.code
          country = "US"
        end
        [state, country]
      end

      def assign_topic(child_name, parent, level)
        topics = Topic.find_all_by_name(child_name)
        topic = topics.detect {|t| t.level == level } unless topics.nil?
        topic = Topic.create(:name => child_name) if topic.nil?
      
        if !topic.parent.nil? && topic.parent.id != parent.id
          puts "Parent inconsistent: can't assign #{topic.name}(#{topic.parent.name}) to #{parent.name}"
        else
          topic.move_to_child_of parent
        end
      end

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

      def parse_msa(msa)
        (msa.blank?) ? nil : MetroServiceArea.find_or_create_by_name(msa)
      end
    
      def parse_activity(str, name="site")
        if str.blank?
          puts "#{name} has no activity!"
        else
          activity = Activity.find_by_description(str.strip)
          activity = Activity.find(1) if activity.nil?
          puts "Unknown activity: #{str} for #{name}" if activity.nil?
        end
        activity
      end
    
      def parse_pref(site, pref)
        if pref =~ /\[(.+?)\]\s*(.+)/
          phrase = $1
          label = $2
          arr = site.key_phrases.select {|kp| kp.phrase == phrase}
          key_phrase = (arr.empty?) ? KeyPhrase.new(:phrase => phrase.strip, :linkable => true) : arr[0]
          key_phrase.label = label
          key_phrase.preferred = true
          site.key_phrases << key_phrase
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

            state, country = parse_state(line[:state])

            site = Site.create :name => line[:name], :url => line[:url], :state => state,
              :country_code => country,
              :city => line[:city], :free => free?(line[:free]), 
              :description => line[:description],
              :registration_required => register?(line[:register]),
              :official => !line[:official].blank?

            1.upto(8) { |i|
              phrase = line["keyword#{i}".to_sym]
              unless phrase.nil? || phrase == "x"
                site.key_phrases << KeyPhrase.new(:phrase => phrase.strip, :linkable => (i<=4))
              end
            }
        
            parse_pref(site, line[:pref1])
            parse_pref(site, line[:pref2])
            parse_pref(site, line[:pref3])

            site.topic = setup_topics(line[:category], line[:ptopic], line[:stopic])
            msa = parse_msa(line[:msa])
            site.metro_service_area = msa unless msa.nil?
            activity = parse_activity(line[:activity], site.name)
            site.activity = activity unless activity.nil?
        
            site.save
          end
          row += 1
        end
        printf "\r%s %-80s\n", "done.", "#{maxrow.to_i} loaded."
      end
    
      # ActiveRecord::Base.connection.execute(
      #   "delete from key_phrases where site_id in (select id from sites where user_id is null)")
      # ActiveRecord::Base.connection.execute("delete from sites where user_id is null")
      # ActiveRecord::Base.connection.execute("delete from topics")
      # ActiveRecord::Base.connection.execute("delete from metro_service_areas")
      # ['topics', 'key_phrases'].each do |table|
      #   ActiveRecord::Base.connection.execute("delete from #{table}")
      # end
      Dir["#{RAILS_ROOT}/data/sites*.csv"].each do |csvfile|
        import_csv(csvfile)
      end
    
    end
  
  end
end