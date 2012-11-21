Platform::Application.routes.draw do

  root :to => 'dashboard#start'

  resources :super_users
  resources :super_user_sessions, only: [:new, :create, :destroy]
  
  resources :companies do
  	resources :users do
      member do
        put 'activate'
      end
    end
  	resources :bills
  	resources :user_sessions, only: [:new, :create, :destroy]
  end

#super_users
  match '/supersignin', to:'super_user_sessions#new'
  match '/supersignout', to:'super_user_sessions#destroy'
  match '/home', :to => 'super_users#home'

#companies
  get '/companies/:company_id/users/verify', :to => 'users#verify'
  get '/companies/:company_id/users/:id/dashboard', :to => 'users#dashboard'
  
  match '/companies/:company_id/signin', to:'user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'user_sessions#destroy', as: 'company_signout'

#bills
  match '/bills', to: 'bills#show_all'

#static_pages
  match '/dashboard', :to => 'dashboard#start'
  
  match '/aboutus' => 'staticpages#aboutus'
  match '/ideas' => 'staticpages#ideas'
  match '/contacts' => 'staticpages#contacts'
end
