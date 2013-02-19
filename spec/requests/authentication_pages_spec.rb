require 'spec_helper'

describe "Authentication" do

    subject { page }

    describe "Sign in page" do
        before { visit signin_path }

        it { should have_selector('title', text: 'GrebeCalendarApp: Sign In') }
        it { should have_selector('h1',    text: 'Sign In') }
    end

    describe "Sign In" do
        before { visit signin_path }

        describe "With invalid information" do
            before { click_button "Sign In" }

            it { should have_selector('h1', text: 'Sign In') }
            it { should have_selector('div.alert.alert-error', text: 'Invalid') }
        end

        describe "With valid information" do
            let(:user) { FactoryGirl.create(:user) }

            before do
                fill_in "Username", with: user.username
                fill_in "Password", with: user.password
                click_button "Sign In"
            end


            it { should have_selector('title', text: user.full_name) }
            it { should have_link('Signout', href: signout_path) }
            it { should_not have_link('Sign In', href: signin_path) }
        end
    end
end
