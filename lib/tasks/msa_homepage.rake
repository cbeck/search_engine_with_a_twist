require 'rubygems'

namespace :ubexact do
  namespace :msa do
  
    desc "Assign MSAs to homepage"
    task :homepage => :environment do

      idx = 1
      %w(newyorkcity dallas miami phoenix minneapolis tampa cincinnati losangeles philadelphia washingtondc boston sandiego baltimore pittsburgh cleveland chicago houston atlanta sanfrancisco seattle stlouis denver portland charlotte).each do |link_name|
        msa = MetroServiceArea.find_by_link_name(link_name)
        unless msa.nil?
          msa.homepage = idx
          idx += 1
          msa.save
        else
          puts "Can't find msa #{link_name}"
        end
      end
      puts "Assigned #{idx} MSAs to homepage"
    
    end
  
  end
end

