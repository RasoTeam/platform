Platform::Application.routes.draw do

  get '/companies/:company_id/users/:user_id/time_offs/manage', :to => 'time_offs#manage'
  get '/companies/:company_id/users/:user_id/time_offs/:id/approve', :to => 'time_offs#approve'

#super_users
  match '/backoffice/supersignin', to:'backoffice/super_user_sessions#new'
  match '/backoffice/supersignout', to:'backoffice/super_user_sessions#destroy'
  match '/backoffice/home', :to => 'backoffice/super_users#home'
  match '/backoffice/bills', to: 'backoffice/bills#show_all'

#companies
  get '/companies/:company_id/users/verify', :to => 'rasocomp/users#verify'
  get '/companies/:company_id/users/:id/dashboard', :to => 'rasocomp/users#dashboard', as: 'user_dashboard'
  
  match '/companies/:company_id/signin', to:'rasocomp/user_sessions#new', as: 'company_signin'
  match '/companies/:company_id/signout', to:'rasocomp/user_sessions#destroy', as: 'company_signout'

#root
  root :to => 'public/frontoffice#index'

  namespace "public" do
    resources :companies
  end

  namespace "backoffice" do
    resources :super_users
    resources :super_user_sessions, only: [:new, :create, :destroy]

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
      resources :user_sessions, only: [:new, :create, :destroy]
    end
  end

    get '/homefront' , :to => 'public/frontoffice#index'
    get '/aboutus' , :to => 'public/frontoffice#aboutus'
    get '/idea' , :to => 'public/frontoffice#idea'
    get '/contacts' , :to => 'public/frontoffice#contacts'
    get '/signup', :to => 'public/frontoffice#new'
end
