FactoryGirl.define do 
	factory :super_user do
		sequence(:name) { |n| "Admin_#{n}" }
		sequence(:email) { |n| "admin_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"
	end

	factory :company do
		sequence(:name) { |n| "Company_#{n}" }
		state 0
		sequence(:slug) { |n| "slug#{n}" }
	end

	factory :user do 
		company_id 1
		state 1
		password "fubarz"
		password_confirmation "fubarz"
		time_off_days 100

		factory :cooperator do
			email "cooperator@rasohr.com"
			name "user cooperator"
			role 10
		end

		factory :manager do
			email "manager@rasohr.com"
			name "user manager"
			role 1
		end
	end 
end
