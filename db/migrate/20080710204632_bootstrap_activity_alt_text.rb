class BootstrapActivityAltText < ActiveRecord::Migration
  def self.up
    Activity.enumeration_model_updates_permitted = true
    
    see_it = Activity.find_by_name("see")
    shop_it = Activity.find_by_name("shop")
    do_it = Activity.find_by_name("do")
    find_it = Activity.find_by_name("find")
    
    see_it.alt_text = "Read news, blogs, read recipes, get advice, check out reference tools, dig up a friend’s number, find computer code, etc."
    shop_it.alt_text = "Shop the latest trends, buy music, movies, plane tickets, a computer, a home, insurance, rent an apartment, apply for credit, etc."
    do_it.alt_text = "Download music, play online games, tour 3D architecture, network with friends, watch TV, blog, upload a pdf, bookmark stuff, etc."
    find_it.alt_text = "Discover Chicago, track down a repair shop, locate your new home town, pinpoint a restaurant, find Mickey Mouse, etc."
    
    see_it.save
    shop_it.save
    do_it.save
    find_it.save
  end

  def self.down
    #nichts
  end
end
