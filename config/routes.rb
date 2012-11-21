Platform::Application.routes.draw do

  root :to => 'dashboard#start'

  get '/companies/:company_id/users/verify', :to => 'users#verify'
  get '/companies/:company_id/users/:user_id/time_offs/manage', :to => 'time_offs#manage'
  get '/companies/:company_id/users/:user_id/time_offs/:id/approve', :to => 'time_offs#approve'

  resources :super_users
  resources :super_user_sessions, only: [:new, :create, :destroy]
  
  
  
  resources :companies do
    resources :users do
      resources :time_offs
    end
    resources :bills
    resources :user_sessions, only: [:new, :create, :destroy]
  end
  
  #map.resources :time_offs, :collection => { :approve => :get }, :member => { :disapprove => :put }

  match '/test', :to => 'dashboard#debug'

  match '/bills', to: 'bills#show_all'

  match '/supersignin', to:'super_user_sessions#new'
  match '/supersignout', to:'super_user_sessions#destroy'
  match '/companies/:company_id/signin', to:'user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'user_sessions#destroy', as: 'company_signout'

  match '/dashboard', :to => 'dashboard#start'

  match '/home', :to => 'super_users#home'
  
  match '/aboutus' => 'staticpages#aboutus'
  match '/ideas' => 'staticpages#ideas'
  match '/contacts' => 'staticpages#contacts'
end
