require 'spec_helper'

describe "Frontoffices" do

	subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_content('about us') }
    it { should have_content('our idea') }
    it { should have_content('contacts') }
    it { should have_content('blog') }

	  it { should have_link('about us', href: aboutus_path) }
	  it { should have_link('our idea', href: idea_path) }
	  it { should have_link('contacts', href: contacts_path) }
	  it { should have_link('blog', href: 'http://rasoblog.herokuapp.com/') }
  

  end

    
  describe "Home page" do
 		before { visit homefront_path }

    it_should_behave_like "all static pages"
    it { should have_selector('title', text: 'Raso') }
    it { should have_link('Try it Free!', href: new_public_company_path) }
  end

  describe "About us" do
  	before {visit aboutus_path}

  	it_should_behave_like "all static pages"
    it { should have_content('Meet the Team') }
  	it {should have_selector('title', text: 'RasoHR | About us')}
  end

  describe "Our idea" do
  	before {visit idea_path}

    it { should have_content('Simple') }
  	it_should_behave_like "all static pages"
  	it {should have_selector('title', text: 'RasoHR | Our idea')}
  end

  describe "Contacts" do
  	before {visit contacts_path}

    it { should have_content('Get in Touch') }
  	it_should_behave_like "all static pages"
  	it {should have_selector('title', text: 'RasoHR | Contacts')}
  end

  describe "sign up/register page" do
  	before { visit new_public_company_path }

  	it { page.should have_content('registration process') }
  end
end
