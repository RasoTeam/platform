require 'spec_helper'

describe Evaluation do

	before do
		@evaluation = Evaluation.new(description: "avaliacao de desempenho", 
			period_begin: Date.today, period_end: Date.today+4 , status: "Active", 
			user_id: 9)
	end

	subject { @evaluation }

	it{ should respond_to(:description)} 
	it{ should respond_to(:period_begin)}
	it{ should respond_to(:period_end)}
	it{ should respond_to(:status)}
	it{ should respond_to(:user_id)}
	#it{ should_not respond_to(:company_id)}

	it { should be_valid }

	describe "when description is not present" do
		before { @evaluation.description = " " }
		it { should_not be_valid }
	end

	describe "when description is too long" do
		before { @evaluation.description = "a" * 100 }
		it { should_not be_valid }
	end

	describe "when the end period is before the start period" do
		before { @evaluation.period_end = Date.yesterday} 
		it { should_not be_valid }
	end

	#Quem sao os user_id? é o responsavel pela avaliaçao certo?
	describe  "when there is no evaluator user" do
		before { @evaluation.user_id = nil }
		it { should_not be_valid }
	end


	describe "when the period dates are invalid" do
		before { @evaluation.period_begin = 91-91-91} 
		it { should_not be_valid }
	end


end