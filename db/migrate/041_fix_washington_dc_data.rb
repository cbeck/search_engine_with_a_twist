class FixWashingtonDcData < ActiveRecord::Migration
  def self.up
    msas = MetroServiceArea.find_all_by_link_name('washingtondc')
    msas.each do |msa|
      if msa.sites.size == 0
        msa.delete
      else
        msa.homepage = 10
        msa.save
      end
    end
  end

  def self.down
  end
end
