include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def sign_out
  click_link "Signout"
end
