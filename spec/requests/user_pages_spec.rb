require 'spec_helper'

describe "UserPages" do

    subject { page }

    describe "Signup Page" do
        before { visit signup_path }

        it { should have_selector('title', text: 'GrebeCalendarApp: Create New Account') }
        it { should have_selector('h1',    text: 'Create Account') }
    end

    describe "signup" do

        before { visit signup_path }

        let(:submit_button) { 'Create Account' }

        describe "with valid information" do
            before do
                fill_in "Full name",    with: "John Doe"
                fill_in "Username",     with: "johnd"
                fill_in "Password",     with: "foobar"
                fill_in "Confirmation", with: "foobar"
            end

            it "should create a user" do
                expect { click_button submit_button }.to change(User, :count).by(1)
            end

            describe "after saving the user" do
                before { click_button submit_button }
        
                let(:user) { User.find_by_username('John Doe') }

                it { should have_selector('title', text: 'John Doe') }
                it { should have_selector('div.alert.alert-success', text: 'Welcome') }
                it { should have_link('Sign out') }
            end
        end

        describe "with invalid information" do
            it "should not create a user" do
                expect { click_button submit_button }.not_to change(User, :count)
            end
      
            describe "error messages" do
                before { click_button submit_button }

                it { should have_selector('title', text: 'Create New Account') }
                it { should have_content('error') }
            end
        end
    end
end
