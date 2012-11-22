Platform::Application.routes.draw do


#backoffice
  match '/backoffice/stats', :to => 'backoffice/super_users#stats'
  match '/backoffice/bills', to: 'backoffice/bills#show_all'

#rasocomp
  get '/companies/:company_id/users/:user_id/time_offs/manage', :to => 'rasocomp/time_offs#manage'
  get '/companies/:company_id/users/:user_id/time_offs/:id/approve', :to => 'rasocomp/time_offs#approve'

  get '/companies/:company_id/users/verify', :to => 'rasocomp/users#verify'
  get '/companies/:company_id/users/:id/dashboard', :to => 'rasocomp/users#dashboard', as: 'user_dashboard'

#public
  match '/companies/:company_id/signin', to:'public/user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'public/user_sessions#destroy', as: 'company_signout'
  match '/supersignin', to:'public/super_user_sessions#new', as: 'super_user_signin'
  match '/supersignout', to:'public/super_user_sessions#destroy', as: 'super_user_signout'
  get '/homefront' , :to => 'public/frontoffice#index'
  get '/aboutus' , :to => 'public/frontoffice#aboutus'
  get '/idea' , :to => 'public/frontoffice#idea'
  get '/contacts' , :to => 'public/frontoffice#contacts'
  get '/signup', :to => 'public/frontoffice#new'

#root
  root :to => 'public/frontoffice#index'

#resources
  namespace "public" do
    resources :user_sessions, only: [:new, :create, :destroy]
    resources :super_user_sessions, only: [:new, :create, :destroy]

#job_offers de candidatos
 # get '/companies/:company_id/job_offers/appliances', :to => 'rasocomp/job_offers#appliances'   , as: 'apply_index'
 # get '/companies/:company_id/job_offers/:id/showapply' , :to => 'rasocomp/job_offers#showapply' , as: 'apply_show'
 # get '/companies/:company_id/job_offers/:id/formapply' , :to => 'rasocomp/job_offers#formapply'  , as: 'apply_form'
 # post '/companies/:company_id/job_offers/:id/formapply' , :to => 'rasocomp/job_offers#createapply'  , as: 'apply_create'

  #job_offers extra de empresas
  #get '/companies/:company_id/job_offers'

  #root :to => 'rasocomp/dashboard#start'
    resources :companies do
      resources :users
    end
  end

  namespace "backoffice" do
    resources :super_users

    resources :companies do
      resources :users
      resources :bills
    end
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
      resources :job_offers , :only => [:index ,:new , :create ,:show ,:delete,:edit ,:update ,:destroy]
    end
  end
end
