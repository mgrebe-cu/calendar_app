include ApplicationHelper

def sign_in(user)
  visit signin_path
  fill_in "Username", with: user.username
  fill_in "Password", with: user.password
  click_button "Sign In"
end

def find_modal_element(modal_element_id)
  wait_until { page.find(modal_element_id).visible? }
end