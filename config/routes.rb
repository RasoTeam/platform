Platform::Application.routes.draw do

  get '/companies/:company_id/users/:user_id/time_offs/manage', :to => 'time_offs#manage'
  get '/companies/:company_id/users/:user_id/time_offs/:id/approve', :to => 'time_offs#approve'

#super_users
  match '/supersignin', to:'backoffice/super_user_sessions#new'
  match '/supersignout', to:'backoffice/super_user_sessions#destroy'
  match '/home', :to => 'backoffice/super_users#home'

#companies
  get '/companies/:company_id/users/verify', :to => 'rasocomp/users#verify'
  get '/companies/:company_id/users/:id/dashboard', :to => 'rasocomp/users#dashboard', as: 'user_dashboard'
  
  match '/companies/:company_id/signin', to:'rasocomp/user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'rasocomp/user_sessions#destroy', as: 'company_signout'
#bills
  match '/bills', to: 'rasocomp/bills#show_all'

#static_pages
  match '/dashboard', :to => 'rasocomp/dashboard#start'
  
  #match '/aboutus' => 'staticpages#aboutus'
  #match '/ideas' => 'staticpages#ideas'
  #match '/contacts' => 'staticpages#contacts'

  #root :to => 'rasocomp/dashboard#start'
  root :to => 'frontoffice/frontoffice#index'

  scope :module => "backoffice" do
    resources :super_users
    resources :super_user_sessions, only: [:new, :create, :destroy]
  end

  scope :module => "rasocomp" do
    resources :companies do
      resources :users do
        member do
          put 'activate'
        end
	resources :time_offs
      end
      resources :bills
      resources :user_sessions, only: [:new, :create, :destroy]
    end
  end

    get '/homefront' , :to => 'frontoffice/frontoffice#index'
    get '/aboutus' , :to => 'frontoffice/frontoffice#aboutus'
    get '/idea' , :to => 'frontoffice/frontoffice#idea'
    get '/contacts' , :to => 'frontoffice/frontoffice#contacts'
    get '/signup', :to => 'frontoffice/frontoffice#new'
end
