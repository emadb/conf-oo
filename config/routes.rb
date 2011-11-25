ConfOo::Application.routes.draw do
  root :to => "home#index"

  devise_for :users

  devise_scope :user do
    get "/login" => "sessions#new"
  end
  
  match 'approve/:id', :to => 'proposals#approve', :as => "approve_proposal"
  match 'unapprove/:id', :to => 'proposals#unapprove', :as => "unapprove_proposal"

  match '/auth/:provider/callback' => 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  match '/signout' => 'sessions#destroy', :as => :signout
  match '/signin' => 'sessions#new', :as => :signin

  match 'polls/save', :to => 'polls#save'
  match 'polls/login', :to => 'polls#login'

  match 'authenticate', :to => 'home#authenticate'
  match 'admin_area', :to => 'home#admin_area'

  resources :proposals
  resources :speeches
  resources :polls
  resources :attendees

  match 'attendees/already_registered', :to =>'attendees#already_registered'
  match 'attendees/confirm', :to =>'attendees#confirm'


  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
