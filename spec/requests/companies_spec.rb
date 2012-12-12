# == Schema Information
#
# Table name: companies
#
# id :integer not null, primary key
# name :string(255)
# logo_url :string(255)
# address :string(255)
# nif :string(255)
# state :integer
# created_at :datetime not null
# updated_at :datetime not null
# tag :string(255)
# password_digest :string(255)
#

require 'spec_helper'

describe Company do
  
  before do
    @company = Company.new(name: "test company inc", slug: "tci", 
    	logo_url: "http://somelogo.com", address: "company address, 123", 
    	state: 0, nif: 123456789 )
  end

  subject { @company }

  it { should respond_to(:name) }
  it { should respond_to(:slug) }
  it { should respond_to(:address) }
  it { should respond_to(:nif) }
  it { should respond_to(:logo_url) }
  it { should respond_to(:state) }

  it { should be_valid }

  describe "when name in not present" do
    before { @company.name = " " }
    it { should_not be_valid }
  end

  describe "when slug in not present" do
    before { @company.slug = " " }
    it { should_not be_valid }
  end

  describe "when state in not present" do
    before { @company.state = nil }
    it { should_not be_valid }
  end

  #testar comprimento do nome
  describe "when name is too long" do
    before { @company.name = "a" * 101 }
    it { should_not be_valid }
  end

  #testar comprimento da tag, formato da tag e singularidade da tag
  describe "when slug is too short" do
    before { @company.slug = "a" * 2 }
    it { should_not be_valid }
  end

  describe "when slug is too long" do
    before { @company.slug = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when slug format is invalid" do
    it "should be invalid" do
      tags = %w[asd-+ *A* AxS-# -asd _sad]
      tags.each do |invalid_tag|
        @company.slug = invalid_tag
        @company.should_not be_valid
      end
    end
  end

  describe "when slug format is valid" do
    it "should be valid" do
      tags = %w[asd_ asd- a-s-d a_s_d]
      tags.each do |valid_tag|
        @company.slug = valid_tag
        @company.should be_valid
      end
    end
  end

  describe "when slug is already taken" do
    before do
      company_with_same_tag = @company.dup
      company_with_same_tag.save
    end
    
    it { should_not be_valid }
  end

  describe "when address is too long" do
  	before { @company.address = "a" * 256 }
    it { should_not be_valid }
  end

  describe "when nif is too long" do
  	before{ @company.nif = 9999999999  }
  	it { should_not be_valid }
  end
end