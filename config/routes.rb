Platform::Application.routes.draw do

  root :to => 'dashboard#start'

  resources :super_users
  resources :super_user_sessions, only: [:new, :create, :destroy]
  resources :companies do
    resources :users
    resources :bills
    resources :user_sessions, only: [:new, :create, :destroy]
  end


  match 'company_root/:id', to:  'companies#show', as: 'company_root'

  match '/bills', to: 'bills#show_all'

  match '/supersignin', to:'super_user_sessions#new'
  match '/supersignout', to:'super_user_sessions#destroy'
  match '/companies/:company_id/signin', to:'user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'user_sessions#destroy', as: 'company_signout'

  match '/dashboard', :to => 'dashboard#start'
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
  # match ':controller(/:action(/:id))(.:format)'
end
