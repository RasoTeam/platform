require 'spec_helper'

describe "Public pages" do

   subject { page }

   shared_examples_for "all frontoffice pages" do
      it { should have_content('Raso') }
      it { should have_content('Company') }
      it { should have_content('Calendar') } 
      it { should have_content('Logout') }  

      it { should have_link('Raso', href: user_dashboard_path) }
      it { should have_link('Company', href: company_path) }
      it { should have_link('Calendar', href: calendar_path) } 
      it { should have_link('Logout', href: company_signout_path) } 
   end


   shared_examples_for "manager pages" do
      it_should_behave_like "all frontoffice pages"

      it { should have_content('Job Offers') }
      it { should have_content('Time Offs') }
      it { should have_content('Trainings') }
      it { should have_content('Employees') }
      it { should have_content('Evaluations') }

      it { should have_link('Raso Admin', href: backoffice_stats_path) }
      it { should have_link('Companies', href: backoffice_companies_path) }
      it { should have_link('Invoices', href: backoffice_bills_path) }
      it { should have_link('Super User Sign Out', href: super_user_signout_path) }
  end

   let(:company) { FactoryGirl.create(:company) }
   let(:manager) { FactoryGirl.create(:manager) }


   before (:each) do   
      valid_user_signin manager
   end

  describe "Evaluation page" do
    before { visit company_evaluations_path(1) }

    it_should_behave_like "manager pages"

    it { should have_selector('h2', text: 'Evaluations') }

   end
end