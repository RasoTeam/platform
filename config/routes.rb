Platform::Application.routes.draw do

resources :feedbacks

  match '/companies/:company_id/calendar(/:year(/:month))' => 'calendar#index', :as => :calendar, :constraints => {:year => /\d{4}/, :month => /\d{1,2}/}

#backoffice
  match '/backoffice/stats', :to => 'backoffice/super_users#stats'
  match '/backoffice/bills', to: 'backoffice/bills#show_all'
  put 'backoffice/companies/:id/block', :to => 'backoffice/companies#block', :as => 'block_company'
  put 'backoffice/companies/:id/activate', :to => 'backoffice/companies#activate', :as => 'activate_company'

#rasocomp
  put  '/companies/:company_id/users/update_credits_to_all' ,
          :to => 'rasocomp/users#update_credits_to_all' , :as => 'update_credits_to_all'
  put '/companies/:company_id/users/:id/resend_verification_email', :to => 'rasocomp/users#resend_verification_email', as: 'user_resend_verification_email'
  put '/companies/:company_id/users/:id/activate_account', :to => 'rasocomp/users#activate_account', as: 'user_activate_account'
  put '/companies/:company_id/users/:id/deactivate_account', :to => 'rasocomp/users#deactivate_account', as: 'user_deactivate_account'

  get '/companies/:company_id/users/:user_id/time_offs/manage', :to => 'rasocomp/time_offs#manage'
  get '/companies/:company_id/users/:user_id/time_offs/:id/approve', :to => 'rasocomp/time_offs#approve'

  get '/companies/:company_id/users/:id/edit_password', :to => 'rasocomp/users#edit_password', :as => 'edit_password_company_user'
  post '/companies/:company_id/users/:id/update_password', :to => 'rasocomp/users#update_password', :as => 'update_password_company_user'

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
  #post '/public/companies/:company_id/job_offers/:id/new' , :to => 'public/job_offers#create_xml' , :as => 'create_apply_xml'

  #linkedin links
  match '/public/companies/:company_id/job_offers/:id/oauth_account' ,
        :to =>'public/job_offers#oauth_account' , :as => 'linkedin_oauth'
  get '/public/companies/:company_id/job_offers/:id/linkedin_profile' ,
        :to => 'public/job_offers#linkedin_profile' , :as => 'linkedin_profile'
  #get  '/public/companies/:company_id/job_offers/:id/profile_saved' ,
        #:to => 'public/job_offers#nada' , :as => 'nada_profile'
  post  '/public/companies/:company_id/job_offers/:id/linkedin_profile' ,
          :to => 'public/job_offers#save_linkedin_profile' , :as => 'save_linkedin_profile'

  #xml links
  match '/public/companies/:company_id/job_offers/:id/xml_profile',
        :to => 'public/job_offers#xml_profile' , :as => 'xml_profile'
  match  '/public/companies/:company_id/job_offers/:id/save_xml_profile' ,
        :to => 'public/job_offers#save_xml_profile' , :as => 'save_xml_profile'

  #pdf links
  match '/public/companies/:company_id/job_offers/:id/pdf_profile',
        :to => 'public/job_offers#pdf_profile' , :as => 'pdf_profile'
  match  '/public/companies/:company_id/job_offers/:id/save_pdf_profile' ,
        :to => 'public/job_offers#save_pdf_profile' , :as => 'save_pdf_profile'

  match  '/public/companies/:company_id/job_offers/:id/cancel_profile' ,
        :to => 'public/job_offers#cancel_profile' , :as => 'cancel_profile'

  #candidates links
  get 'companies/:company_id/job_offers/:job_offer_id/candidates/:id',
        :to => 'rasocomp/candidates#show' , :as => 'show_candidate'

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
      resources :users do
        resources :periods
      end
      resources :bills
    end
  end

  scope :module => "rasocomp" do
    resources :companies do
      resources :trainings do
        collection do
          get :manage
        end
        resources :courses do
          member do
            put :update_users
            put :activate
            put :enroll
            put :unenroll
          end
        end
      end
      #Import Controller Routes
      resources :importsingle do
        collection do
          get :fst_step
          post :snd_step
          post :trd_step
          post :default_confirmation_step
          post :final_import_step
          post :import_another
          post :finalize
        end
      end
      resources :users do
        resources :contracts
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
