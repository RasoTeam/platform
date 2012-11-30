FactoryGirl.define do 
	factory :super_user do
		sequence(:name) { |n| "Admin_#{n}" }
		sequence(:email) { |n| "admin_#{n}@example.com" }
		password "foobar"
		password_confirmation "foobar"
	end

	factory :company do
		# Criar empresa
	end
end
