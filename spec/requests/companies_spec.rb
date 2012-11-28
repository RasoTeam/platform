require 'spec_helper'

describe "CompaniesPages" do

	subject { page }

  describe "companies page" do
  	before { visit backoffice_companies_path }

    it "should have the content 'Companies'" do
    	page.should have_content('Companies')
    end

    it { should have_selector('h1', text: 'Companies') }
    it { should have_selector('title', text: 'RasoHR | Companies') }
  end
end
