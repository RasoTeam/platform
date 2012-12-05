require 'spec_helper'

describe "CompaniesAuthentications" do

  describe "sign in" do
    before { visit company_signin_path }

    describe "with invalid information" do
      before do
        fill_in "user_session_email", with: "invalid email@mail.com"
        fill_in "user_session_password", with: "password"
        click_button "Sign In"
      end
    
      it { should have_alert_message('Email is invalid') }
    end

    describe "with wrong password" do
      before do
        fill_in "user_session_email", with: "validemail@mail.com"
        fill_in "user_session_password", with: "__"
        click_button "Sign In"
      end

      it { should have_alert_message('Wrong password') }
    end
  end
end
