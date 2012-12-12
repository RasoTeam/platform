require 'spec_helper'

describe JobOffer do

	let(:company) { FactoryGirl.create(:company) }
	before do
		@joboffer = JobOffer.new(job_name: "nome do trabalho", 
			description: "descricao do trabalho", skills: "12 ano",
			conditions: "ser escravizado", status: "Open")
	end

	subject { @joboffer }

	it { should respond_to(:job_name) }  
	it { should respond_to(:description) }  
	it { should respond_to(:required_education) }  
	it { should respond_to(:skills) }  
	it { should respond_to(:status) }  
	it { should respond_to(:conditions) }   
	it { should respond_to(:company_id) }   

	it { should be_valid }

	describe "accessible attributes" do

		it "should not allow access to company_id" do
			expect do
				JobOffer.new(company_id: company.id)
			end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
		end
	end

#CORRIGIR ISTO
	describe "with required fields not present" do
		
		describe "job_name" do
			before { @joboffer.job_name = nil }
			it { should_not be_valid }
		end

		describe "description" do
			before { @joboffer.description = nil }
			it { should_not be_valid }
		end

		describe "skills" do
			before { @joboffer.skills = nil }
			it { should_not be_valid }
		end

		describe "conditions" do
			before { @joboffer.conditions = nil }
			it { should_not be_valid }
		end

		describe "status" do
			before { @joboffer.status = nil }
			it { should_not be_valid }
		end		
	end

	describe "with required fields blank" do

		describe "job_name" do
			before { @joboffer.job_name = " " }
			it { should_not be_valid }		
		end

		describe "description" do
			before { @joboffer.description = " " }
			it { should_not be_valid }
		end

		describe "skills" do
			before { @joboffer.skills = " " }
			it { should_not be_valid }
		end

		describe "conditions" do
			before { @joboffer.conditions = " " }
			it { should_not be_valid }
		end
		
		describe "status" do
			before { @joboffer.status = " " }
			it { should_not be_valid }
		end
	end

	describe "with job_name that is too long" do

		before { @joboffer.job_name = "a" * 150 }
		it { should_not be_valid }
	end
end
