ActionController::Routing::Routes.draw do |map|
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
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  map.root :controller => "landing"
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.resources :posts, :path_prefix => '/group/:group_id/category/:category_id/users/:user_id',:name_prefix => 'group_'   
  map.resources :groups,:member => { :join => :get,:members => :get,:activity => :get } do |group|
    group.resource :wiki,:member => {:page => :get,:preview => :put, :annotate => :get,
      :protect => :post, :rename => [:get,:post], :history => :get, :diff => :get, :special => :get}
  end
  map.group_category '/group/:group_id/category/:category_id', :controller => 'categories', :action => 'show'
  map.accpet_pending_group_member '/groups/:group_id/members/:member_id', :controller => 'groups', :action => 'accept'
  map.from_plugin :community_engine 
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
