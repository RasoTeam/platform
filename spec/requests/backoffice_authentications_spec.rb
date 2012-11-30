require 'spec_helper'

describe "BackofficeAuthentications" do

  subject { page }

  describe "signin page" do
  	before { visit super_user_signin_path }

		it { should have_selector('h1', text: 'Raso Admin') }
  	it { should have_selector('title', text: 'RasoHR | Admin sign in') }
  	it { should have_button('Sign In') }
  	it { should_not have_content('company login page') }
  	it { should_not have_selector('div.row.alert-box.error') }
  end

  describe "sign in" do
  	before { visit super_user_signin_path }

  	describe "with INVALID information" do
  		before do
  			fill_in "Email", with: "i n v a l i d@email."
  			fill_in "Password", with: "password"
  			click_button "Sign In"
  		end

  		it { should have_selector('title', text: 'RasoHR | Admin sign in') }
  		it { should have_error_message('Wrong') }
  #		it { should have_selector('div.row.alert-box.error', text: 'Wrong') }
  		it { should have_content('Raso Admin') }

   		describe "after visiting another page" do
  			before { click_link "about us" }
  			it { should_not have_selector('div.row.alert-box.error') }
  		end

  		describe "__________DEBUGz_____________" do
  			before { click_link "register company" }
  			it { should have_content('registation process') }
  		end
  	end
  
		describe "with VALID information" do
	  	let(:admin) { FactoryGirl.create(:super_user) }
	  	before { valid_admin_signin(admin) }

	  	it { should have_selector('title', text: 'RasoHR | Backoffice') }

	  	it { should have_content('Backoffice') }

	    it { should have_link('SuperUsers',   href: backoffice_super_users_path) }
	  	it { should have_link('Companies',  	href: backoffice_companies_path) }
	    it { should have_link('Invoices', 		href: backoffice_bills_path) }
	  	it { should have_link('Super User Sign Out', href: super_user_signout_path) }
	      
	  	it { should_not have_link('Sign in', href: super_user_signin_path) }

	  	describe "visit Companies page" do
	  		before { click_link 'Companies' }

	  		it { should have_content('SLUG') }
	  	end

	  	describe "followed by signout" do
	  	#	before { click_link "Super User Sign Out" }
	  	#	before { delete super_user_signout_path }
	  		before { delete public_super_user_session_path }
	  		# <%= link_to "Sign out", signout_path, method: "delete" %>


	  		it { should have_link('register company') }
	    	it { should_not have_link('Companies',  href: backoffice_companies_path) }
	    	it { should_not have_link('Invoices', 	href: backoffice_bills_path) }
	  		it { should_not have_link('Super User Sign Out', href: super_user_signout_path) }
	  	end
	  end
  end

  describe "authorization" do

    describe "for non-signed-in admins" do
      let(:admin) { FactoryGirl.create(:super_user) }

      it { should_not have_link('Rase Admin',  href: backoffice_stats_path) }
      it { should_not have_link('Companies', href: backoffice_companies_path) }
      it { should_not have_link('Invoices', href: backoffice_bills_path) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_backoffice_super_user_path(admin)
          fill_in "Email",    with: admin.email
          fill_in "Password", with: admin.password
          click_button "Sign In"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: "Edit a Super User")
          end

          describe "when signing in again" do
            before do
            	#FIX THE LOGOUT!
              delete public_super_user_session_path
              visit super_user_signin_path
              fill_in "Email",    with: admin.email
              fill_in "Password", with: admin.password
              click_button "Sign In"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: 'RasoHR | Backoffice')
              page.should have_selector('h2', text: 'Welcome to RASO Backoffice')
            end
          end
        end
      end

      describe "in the Super Users controller" do

        describe "visiting the edit page" do
          before { visit edit_backoffice_super_user_path(admin) }
          it { should have_selector('title', text: 'RasoHR | Admin sign in') }
          it { should have_selector('h1', text: 'Raso Admin') }
        end

        describe "submitting to the update action" do
          before { put backoffice_super_user_path(admin) }
          specify { response.should redirect_to(super_user_signin_path) }
        end

        describe "visiting the user index" do
          before { visit backoffice_super_users_path}
          it { should have_selector('title', text: 'RasoHR | Admin sign in') }
          it { should have_selector('h1', text: 'Raso Admin') }
        end
      end
    end

    describe "as a wrong user" do
      let(:admin) { FactoryGirl.create(:super_user) }
      let(:wrong_admin) { FactoryGirl.create(:super_user, email: "wrong@example.com") }
      before { valid_admin_signin admin }

      describe "visiting super_users#edit page" do
        before { put backoffice_super_user_path(wrong_admin) }
        specify { response.should redirect_to(backoffice_super_user_path(admin)) }
      end
    end

#EDIT FOR A COMPANY TO DELETE A SUPER USER?! xD
    # describe "as non-admin user" do
    #   let(:user) { FactoryGirl.create(:user) }
    #   let(:non_admin) { FactoryGirl.create(:user) }

    #   before { valid_signin non_admin }

    #   describe "submitting a DELETE request to the Users#destroy action" do
    #     before { delete user_path(user) }
    #     specify { response.should redirect_to(root_path) }
    #   end
    # end
  end
end
