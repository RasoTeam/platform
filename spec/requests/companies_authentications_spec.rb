require 'spec_helper'

describe "CompaniesAuthentications" do

  subject { page }

  let(:comp) { FactoryGirl.create(:company) }
  let(:user) { FactoryGirl.create(:cooperator) }

  describe "sign in" do
    before { visit company_signin_path(comp.slug) }

    describe "with wrong email" do
      before do
        fill_in "user_session_email", with: user.email+"a"
        fill_in "user_session_password", with: "fubarz"
        click_button "Sign In"
      end
    
      it { should have_alert_message('Wrong username or password!') }
    end

    describe "with wrong password" do
      before do
        fill_in "user_session_email", with: user.email
        fill_in "user_session_password", with: "wrongpass"
        click_button "Sign In"
      end

      it { should have_alert_message('Wrong username or password!') }
    end

    describe "with valid login" do
      before { valid_user_signin(user) }

      it { should have_content('Dashboard') }
    end
  end
end
