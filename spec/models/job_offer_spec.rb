require 'spec_helper'

describe JobOffer do

	before do
		@joboffer = JobOffer.new(job_name: "job offer test", 
					description: "description of the offer")
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
end
