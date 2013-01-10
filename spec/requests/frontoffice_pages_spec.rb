require 'spec_helper'

describe "Frontoffice pages" do

   subject { page }

   let(:slug) { "compslug" }

   shared_examples_for "all frontoffice pages" do
      it { should have_content('Raso') }
      it { should have_content('Company') }
      it { should have_content('Calendar') } 
      it { should have_content('Logout') }  

      it { should have_link("company name", href: user_dashboard_path(slug, user.id)) }
      it { should have_link('Company', href: company_path(slug)) }
      it { should have_link('Calendar', href: calendar_path(slug)) } 
      it { should have_link('Logout', href: company_signout_path(slug)) } 
   end


   shared_examples_for "manager pages" do
      it { should have_content('Job Offers') }
      it { should have_content('Time Offs') }
      it { should have_content('Trainings') }
      it { should have_content('Employees') }
      it { should have_content('Evaluations') }

      it { should have_link('Job Offers', href: company_job_offers_path(slug)) }
      it { should have_link('Time Offs', 
         href: manage_company_user_time_offs_path(slug, user.id)) }
      it { should have_link('Trainings', href: manage_company_trainings_path(slug)) }
      it { should have_link('Employees', href: company_users_path(slug)) }
      it { should have_link('Evaluations', href: company_evaluations_path(slug))}
   end

   describe "Cooperator user" do

      let(:user) { FactoryGirl.create(:cooperator) }

      before (:each) do   
         valid_user_signin user
         visit company_path(1)
      end

      it_should_behave_like "all frontoffice pages"

      #Testes de Dashboard estão um cagalhao
      describe "Dashboard page" do
         before { visit user_dashboard_path(slug, user.id) }

         it { should have_content('Contract') }
         it { should have_selector('h4', text: 'company name') }
        # it { should have_link('Dashboard', href: dashboard) } 
         it { should have_selector('img', text: 'Foto da Pessoa')}
         it { should have_content('Address') }
      end

      describe "Company page" do
         before { visit company_path(slug) }

         it { should have_selector('h4', text: 'company name') }
         it { should have_content('NIF') }
         it { should have_content('Address') }
         it { should have_content('WWW') }
         it { should have_content('Employees') }
      end

      describe "Calendar page" do
         before { visit calendar_path(slug) }

         it { should have_selector('h1', text: 'Calendar') }
         it { should have_content('Mon') }
         it { should have_content(Date::MONTHNAMES[Date.today.month]) }
      end
   end

   describe "Manager user" do
      #Company foi criada na consola de teste do rails.. nao consegui usar a FactoryGirl
      #let(:company) { FactoryGirl.create(:company) }
      let(:user) { FactoryGirl.create(:manager) }

      before (:each) do   
         valid_user_signin user
         #visit user_dashboard_path(1)
         visit company_path(1)
      end

      it_should_behave_like "all frontoffice pages"
      it_should_behave_like "manager pages"


      describe "Job Offers page" do
         before { visit company_job_offers_path(slug) }

         it { should have_selector('h2', text: 'Job Offers') }
         it { should have_link('See Public Page', href: public_company_job_offers_path(slug)) }
         it { should have_link('Create Job Offer', href: new_company_job_offer_path(slug)) }
      end


      describe "Time Offs page" do
         before { visit manage_company_user_time_offs_path(slug, user.id) }

         it { should have_selector('h2', text: 'Manage Time Offs') }
         it { should have_content('Cooperator name') }
         it { should have_link('Accept', href: approve_company_user_time_off_path(slug, user.id)) }
      end

      describe "Evaluation page" do
         before { visit company_evaluations_path(slug) }

         it { should have_selector('h2', text: 'Evaluations') }
      end
   end


end