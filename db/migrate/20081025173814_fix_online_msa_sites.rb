class FixOnlineMsaSites < ActiveRecord::Migration
  def self.up
    online_msa = MetroServiceArea.find_by_link_name('online')
    online_msa.sites.each {|s|
      s.online = true
      s.metro_service_area = nil
      s.save
    }
    
    online_msa.destroy
    
    #now find stragglers
    stragglers = Site.find_all_by_metro_service_area_id(nil, :conditions => ['online is NULL or online = ?', false])
    stragglers.each {|s|
      s.online = true
      s.save 
    }    
  end

  def self.down
    online_msa = MetroServiceArea.create(:name => 'Online')
    online_sites = Site.find_all_by_metro_service_area_id(nil)
    online_sites.each{|s|
      s.metro_service_area = online_msa
      s.save
    }
  end
end
