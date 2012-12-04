require 'spec_helper'

describe "Backoffice pages" do

	subject { page }

	shared_examples_for "all backoffice pages" do
    it { should have_content('Raso Admin') }
    it { should have_content('Companies') }
    it { should have_content('Invoices') }
    it { should have_content('Super User Sign Out') }

	  it { should have_link('Raso Admin', href: backoffice_stats_path) }
	  it { should have_link('Companies', href: backoffice_companies_path) }
	  it { should have_link('Invoices', href: backoffice_bills_path) }
	  it { should have_link('Super User Sign Out', href: super_user_signout_path) }
  end

	let(:admin) { FactoryGirl.create(:super_user) }

	before (:each) do
		valid_admin_signin admin
		visit backoffice_stats_path
	end

	describe "Stats page" do
		
    it_should_behave_like "all backoffice pages"
		it { should have_selector('h1', text: 'Welcome to RASO Backoffice') }
		it { should have_content('Total in Debt') }
	end

	describe "SuperUsers page" do
		before { visit backoffice_super_users_path }

		it_should_behave_like "all backoffice pages"
		it { should have_selector('h1', text: 'All SuperUsers' ) }
		it { should have_content(admin.name) }
		it { should have_link('Create a New Super User', href: new_backoffice_super_user_path) }

		describe "a SuperUser page" do
			before { visit backoffice_super_user_path(admin) }

			it { should have_selector('h1', text: admin.name) }
			it { should have_content(admin.email) }
			it { should have_link('Delete') } 
			it { should have_link('Back to Super Users List', href: backoffice_super_users_path) }
		end

		describe "delete links" do
      let(:admintemp) { FactoryGirl.create(:super_user) }

			describe "delete another SuperUser" do
      	before{ visit  backoffice_super_user_path(admintemp)}

        it { should_not have_link('Delete', href: backoffice_super_user_path(admintemp)) }
        it "should not be able to delete the other user" do
          expect { click_link('Delete') }.not_to change(SuperUser, :count)
        end
      end

      describe "delete himself" do
				before {visit backoffice_super_user_path(admin)}

 				it "should be able to delete himself" do
        	expect { click_link('Delete') }.to change(SuperUser, :count).by(-1)
        end
      end
    end
	end

	describe "Companies page" do
		before { visit backoffice_companies_path }

		it_should_behave_like "all backoffice pages"
		it { should have_selector('h1', text: 'Companies') }
		it { should have_content('Name') }
		it { should have_content('SLUG') }
		it { should have_content('NIF') }
		it { should have_content('Status') }
		it { should have_content('Actions') }
		it { should have_selector('input[name=search]') }

	end

	describe "Invoices page" do
		before { visit backoffice_bills_path }

		it_should_behave_like "all backoffice pages"
		it { should have_selector('h1', text: 'Invoices') }
		it { should have_content('Cod.') }
		it { should have_content('Company') }
		it { should have_content('Date') }
		it { should have_content('Amount') }
		it { should have_content('Status') }
		it { should have_content('Actions') }
		it { should have_selector('input[name=search]') }

	end
end