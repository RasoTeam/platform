require 'spec_helper'

describe "Public pages" do

	subject { page }
  
  shared_examples_for "all public pages" do
    it { should have_content('team') }
    it { should have_content('idea') }
    it { should have_content('contacts') }
    it { should have_content('blog') }

	  it { should have_link('team', href: aboutus_path) }
	  it { should have_link('idea', href: idea_path) }
	  it { should have_link('contacts', href: contacts_path) }
	  it { should have_link('blog', href: 'http://rasoblog.herokuapp.com/') }
  end

    
  describe "Home page" do
 		before { visit root_path }

    it_should_behave_like "all public pages"
    
    it { should have_selector('title', text: 'RasoHR') }
    it { should have_link('Try it Free!', href: new_public_company_path) }
  end

  describe "Team/About us" do
  	before {visit aboutus_path}

  	it_should_behave_like "all public pages"
    it { should have_content('Meet the Team') }
  	it {should have_selector('title', text: 'RasoHR | About us')}
  end

  describe "idea" do
  	before {visit idea_path}

    it_should_behave_like "all public pages"
    it { should have_selector('h1', text: 'Employee Self Management') }
  	it { should have_selector('title', text: 'RasoHR | Idea') }
    it { should have_content("It's cheap!") }
  end

  describe "Contacts" do
  	before {visit contacts_path}

    it { should have_content('Get in Touch') }
  	it_should_behave_like "all public pages"
  	it {should have_selector('title', text: 'RasoHR | Contacts')}
  end

  describe "sign up/register page" do
  	before { visit new_public_company_path }

  	it { page.should have_content('registration process') }
  end
end
