ActionController::Routing::Routes.draw do |map|
 
  map.login  '/login',  :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.openid '/openid', :controller => 'sessions', :action => 'openid'
  map.history '/history', :controller => 'history', :action => 'show'
  map.suggest '/suggest_a_link', :controller => 'sites', :action => 'new'

  # /search/:term/topic/:topic/msa/:msa
  # /search/:term/topic/:topic
  # /search/:term/msa/:msa
  # /topic/:topic/msa/:msa
  # /topic/:topic
  # /msa/:msa

  map.dns_msa_query '/', :controller => 'search', :action => 'new', 
    :conditions => {:hostname => /ubexact(\w)+msa\./}
  map.dns_query '/', :controller => 'search', :action => 'show', 
    :conditions => {:hostname => /ubexact(\w)+\./}

  # map.search_term '/search/:term', :controller => 'search', :action => 'show'

  map.with_options :controller => 'search' do |m|    
    m.search_index '/search', :action => 'new'
    
    # m.search_page '/search/:term/page/:page', :action => 'search_page'
    m.search_page '/search/:term/msa/:msa/topic/:topic1/:topic2/:topic3', 
      :action => 'show', :topic2 => nil, :topic3 => nil, 
      :requirements => { :term => /.*/}
    
    m.search_msa_topic '/search/:term/msa/:msa/topic/:topic1/:topic2/:topic3', 
      :action => 'show', :topic2 => nil, :topic3 => nil,
      :requirements => { :term => /.*/}
    m.search_topic '/search/:term/topic/:topic1/:topic2/:topic3', 
      :action => 'show', :topic2 => nil, :topic3 => nil,
      :requirements => { :term => /.*/}
    m.search_msa '/search/:term/msa/:msa', 
      :action => 'show', 
      :requirements => { :term => /.*/}
    m.search_term '/search/:term',
      :action => 'show', 
      :requirements => { :term => /.*/}
    m.create_search '/search',
      :action => 'create',
      :conditions => { :method => :post },
      :requirements => { :term => /.*/ }
    m.topic '/topic/:topic1/:topic2/:topic3', 
      :action => 'show', :topic2 => nil, :topic3 => nil
    m.category '/category/:topic1',
      :action => 'show', :category => true
    m.msa_topic '/msa/:msa/topic/:topic1/:topic2/:topic3', 
      :action => 'show', :topic2 => nil, :topic3 => nil
    m.msa '/msa/:msa', 
      :action => 'show'
  end

  # map.resources :search
  
  map.with_options :controller => 'users' do |m|
    m.signup '/signup', :action => 'new'
    m.account '/account', :action => 'edit'
    m.change_password '/account/password', :action => 'change_password'
    m.forgot_password '/forgot_password', :action => 'forgot_password'
    m.initiate_reset_path '/initiate_reset', :action => 'initiate_reset'
    m.activate '/activate/:activation_code', :action => 'activate'
    m.reset_password '/reset_password/:password_reset_code', :action => 'reset_password'
    m.signup_complete '/signup_complete', :action => 'signup_complete'
  end

  map.with_options :controller => 'site' do |m|
    m.about '/about', :action => 'about'
    m.press '/press', :action => 'press'
    m.demo '/demo', :action => 'demo'
    m.privacy '/privacy', :action => 'privacy'
    m.advertising '/advertising', :action => 'advertising'
    m.contact '/contact', :action => 'contact'
    m.admin '/admin', :action => 'admin'
    m.agreement '/agreement', :action => 'agreement'
    m.submit_links_program '/submit_links_program', :action => 'submit_links_program'
    m.hall_of_fame '/user_contributed_hall_of_fame', :action => 'hall_of_fame'
    m.faq '/faq', :action => 'faq'
  end
    
  map.namespace :admin do |admin|
    admin.resources :users, :member => { :suspend => :get, :activate => :get }
    admin.resources :payment_types
    admin.resources :sites, :collection => { :find_msa => :post }
    admin.resources :metro_service_areas
    admin.resources :topics
    admin.resources :metro_service_area_links
    admin.resources :blacklisted_sites
  end
  
  map.resources :metro_service_area_links  
  map.resources :sites
  map.resources :users
  map.resources :sessions, :collection => { :begin => :post, :complete => :get }
  

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "search", :action => "new"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
