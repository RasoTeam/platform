Platform::Application.routes.draw do

resources :feedbacks

  match '/companies/:company_id/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

#backoffice
  match '/backoffice/stats', :to => 'backoffice/super_users#stats'
  match '/backoffice/bills', to: 'backoffice/bills#show_all'

#rasocomp
  get '/companies/:company_id/users/:user_id/time_offs/manage', :to => 'rasocomp/time_offs#manage'
  get '/companies/:company_id/users/:user_id/time_offs/:id/approve', :to => 'rasocomp/time_offs#approve'

  match '/companies/:company_id/users/:id/dashboard', :to => 'rasocomp/users#dashboard', as: 'user_dashboard'

#public
  get '/public/companies/:company_id/users/verify', :to => 'public/users#verify', as: 'email_verify'
  match '/companies/:company_id/signin', to:'public/user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'public/user_sessions#destroy', as: 'company_signout'
  match '/supersignin', to:'public/super_user_sessions#new', as: 'super_user_signin'
  match '/supersignout', to:'public/super_user_sessions#destroy', as: 'super_user_signout'
  get '/homefront' , :to => 'public/frontoffice#index'
  get '/aboutus' , :to => 'public/frontoffice#aboutus'
  get '/idea' , :to => 'public/frontoffice#idea'
  get '/contacts' , :to => 'public/frontoffice#contacts'
  get '/signup', :to => 'public/frontoffice#new'
  get '/public/companies/:company_id/job_offers/:id/new' , :to => 'public/job_offers#new' , :as => 'new_apply'
  post '/public/companies/:company_id/job_offers/:id/new' , :to => 'public/job_offers#create' , :as => 'create_apply'
  post '/public/companies/:company_id/job_offers/:id/new' , :to => 'public/job_offers#create_xml' , :as => 'create_apply_xml'

  #linkedin links
  match '/public/companies/:company_id/job_offers/:id/oauth_account' ,
        :to =>'public/job_offers#oauth_account' , :as => 'linkedin_oauth'
  match '/public/companies/:company_id/job_offers/:id/linkedin_profile' ,
        :to => 'public/job_offers#linkedin_profile' , :as => 'linkedin_profile'



#root
  #match '/' => 'public/companies#show', :constraints => {:subdomain => /.+/}
  #match '/' => 'public/companies#signin', :constraints => {:subdomain => /.+/}
  root :to => 'public/frontoffice#index'

#resources
  namespace "public" do
    resources :super_user_sessions, only: [:new, :create, :destroy]


  #root :to => 'rasocomp/dashboard#start'
    resources :companies do
      resources :job_offers , :only => [:index ,:show ]
      resources :user_sessions, only: [:new, :create, :destroy]
      resources :users do
        member do
          put 'activate'
        end
      end
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
        resources :time_offs do
          collection do
            get :manage
          end
          member do
            put :approve
            put :disapprove
          end
        end
      end
      resources :bills
      resources :job_offers , :only => [:index ,:new , :create ,:show ,:delete,:edit ,:update ,:destroy]
    end
  end

end
