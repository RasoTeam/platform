require 'spec_helper'

describe "CompaniesSignup" do
  
  subject { page }

  describe "signup" do
    before { visit new_public_company_path }

    let(:signup) { "Get Started!" }

    describe "with invalid information" do
      it "should not create a company" do
        expect { click_button signup }.not_to change(Company, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "new_company_name", with: "Test Company Inc"
        fill_in "new_company_tag", with: "tci"
        fill_in "new_company_email", with: "andrefelix53+4@gmail.com"
      end

      
      it "should create a new company" do
        expect { click_button signup }.to ( change(User, :count).by(1) && change(Company, :count).by(1) )
      end
    end
  end
end
