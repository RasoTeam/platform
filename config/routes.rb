Platform::Application.routes.draw do


#super_users
  match '/supersignin', to:'backoffice/super_user_sessions#new'
  match '/supersignout', to:'backoffice/super_user_sessions#destroy'
  match '/home', :to => 'backoffice/super_users#home'

#companies
  get '/companies/:company_id/users/verify', :to => 'rasocomp/users#verify'
  get '/companies/:company_id/users/:id/dashboard', :to => 'rasocomp/users#dashboard'
  
  match '/companies/:company_id/signin', to:'rasocomp/user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'rasocomp/user_sessions#destroy', as: 'company_signout'

#bills
  match '/bills', to: 'rasocomp/bills#show_all'

#static_pages
  match '/dashboard', :to => 'rasocomp/dashboard#start'
  
  match '/aboutus' => 'staticpages#aboutus'
  match '/ideas' => 'staticpages#ideas'
  match '/contacts' => 'staticpages#contacts'

#job_offers de candidatos
  get '/companies/:company_id/job_offers/appliances', :to => 'rasocomp/job_offers#appliances'   , as: 'apply_index'
  get '/companies/:company_id/job_offers/:id/showapply' , :to => 'rasocomp/job_offers#showapply' , as: 'apply_show'
  get '/companies/:company_id/job_offers/:id/formapply' , :to => 'rasocomp/job_offers#formapply'  , as: 'apply_form'
  post '/companies/:company_id/job_offers/:id/formapply' , :to => 'rasocomp/job_offers#createapply'  , as: 'apply_create'

  #job_offers extra de empresas
  #get '/companies/:company_id/job_offers'

  root :to => 'rasocomp/dashboard#start'

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
      end
      resources :bills
      resources :user_sessions, only: [:new, :create, :destroy]

      resources :job_offers , :only => [:index ,:new , :create ,:show ,:delete,:edit ,:update ,:destroy]


    end
  end
end
