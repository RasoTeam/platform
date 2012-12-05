require 'spec_helper'

describe "CompaniesSignup" do
  
  subject { page }

  describe "signup" do
    before { visit new_public_company_path }

    let(:signup) { "Get Started!" }

    describe "with blank information" do
      before do
        click_button "Get Started!"
      end

      it { should have_alert_message('Name can\'t be blank') }
      it { should have_alert_message('Slug can\'t be blank') }
      it { should have_alert_message('Email can\'t be blank') }      

      it "should not create a company" do
        expect { click_button signup }.not_to change(Company, :count)
      end
    end
   
    describe "with invalid information" do
      before do
        fill_in "new_company_name", with: "Test Company Inc"
        fill_in "new_company_slug", with: "tc"
        fill_in "new_company_email", with: "andre felix53+4@gmail.com"
      end

      it { should have_alert_message('Slug is invalid') }
      it { should have_alert_message('Email is invalid') }

      it "should not create a company" do
        expect { click_button signup }.not_to change(Company, :count)
      end


    end

    describe "with valid infermation" do 
      before do
        fill_in "new_company_name", with: "Test Company Inc"
        fill_in "new_company_slug", with: "tci"
        fill_in "new_company_email", with: "andrefelix53+4@gmail.com"
      end

      
      it "should create a new company" do
        expect { click_button signup }.to ( change(User, :count).by(1) && change(Company, :count).by(1) )
      end
    end
  end
end
