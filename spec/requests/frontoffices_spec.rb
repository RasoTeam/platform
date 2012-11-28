require 'spec_helper'

describe "Frontoffices" do

	subject { page }
    
  describe "home page" do
  	before { visit root_path }

    it "should have the content 'about us'" do
    	page.should have_content('about us')
    end

    it { should_have link_to('about us', href: aboutus_path) }

    it { should have_selector('title', text: 'RasoHR') }
  end
end
