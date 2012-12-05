include ApplicationHelper

def valid_admin_signin(admin)
	visit super_user_signin_path
	fill_in "Email", 	with: admin.email
	fill_in "Password",	with: admin.password
	click_button "Sign In"
	# Sign in when not using Capybara as well.
	# cookies[:remember_token] = admin.remember_token
end

Rspec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.row.alert-box.error', text: message)
	end
end

Rspec::Matchers.define :have_alert_message do |message|
        match do |page|
                page.should have_selector('div.alert-box.alert', text: message)
        end
end

