class ChangeMsaLinkNameFormat < ActiveRecord::Migration
  def self.up
    add_column :metro_service_areas, :homepage, :integer
    
    MetroServiceArea.find(:all).each do |msa|
      # changes msa.link_name to not use underscores (using before_save)
      # i.e. new_york => newyork
      msa.save
    end

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
  end

  def self.down
    remove_column :metro_service_areas, :homepage
  end
end
