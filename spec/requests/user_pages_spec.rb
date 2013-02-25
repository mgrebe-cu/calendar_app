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
                fill_in "Full Name",    with: "John Doe"
                fill_in "Username",     with: "johnd"
                fill_in "Password",     with: "foobar1"
                fill_in "Confirmation", with: "foobar1"
            end

            it "should create a user" do
                expect { click_button submit_button }.to change(User, :count).by(1)
            end

            describe "after saving the user" do
                before { click_button submit_button }
        
                let(:user) { User.find_by_username('John Doe') }

                it { should have_selector('title', text: 'John Doe') }
                it { should have_selector('div.alert.alert-success', text: 'Welcome') }
                it { should have_link('Signout') }
            end
        end

        describe "with invalid information" do
            it "should not create a user" do
                expect { click_button submit_button }.not_to change(User, :count)
            end
      
            describe "error messages" do
                before { click_button submit_button }

                it { should have_selector('title', text: 'Create New Account') }
                it { should have_content("can't be blank") }
            end
        end
    end

    describe "settings" do
        let(:user) { FactoryGirl.create(:user) }
        let(:calendar) { FactoryGirl.create(:calendar, user: user) }

        before do
            calendar.save
            sign_in user
            visit edit_user_path(user)
        end

        describe "page" do
            it { should have_selector('h1',    text: "Update your settings") }
            it { should have_selector('title', text: "Edit settings") }
        end

        describe "with full name change" do
            let(:new_name)  { 'New Name' }
            before do
                fill_in 'Full Name',        with: new_name
                click_button 'Save changes'
            end

            it { should have_selector('title', text: new_name) }
            it { should have_selector('div.alert.alert-success') }
            it { should have_link('Signout', href: signout_path) }
            specify { user.reload.full_name.should  == new_name }
        end

        describe "with default view change" do
            before do
                select 'Day', :from => 'Default view'
                click_button 'Save changes'
                visit edit_user_path(user)
            end

            it { should have_field('Default view', text: 'Day') }
            specify { user.reload.default_view.should  == 'day' }
        end

        describe "with new password" do
            describe "with invalid information" do
                before { click_button 'Change password' }

                it { should have_selector('title', text: 'Edit settings') }
                it { should have_content("can't be blank") }
            end

            describe "with valid information" do
                before do
                    fill_in "Password",     with: "foobar2"
                    fill_in "Confirmation", with: "foobar2"
                    click_button 'Change password'
                end

                it { should have_selector('title', text: user.full_name) }
                it { should have_selector('div.alert.alert-success') }
            end
        end
    end

    describe "home" do
        let(:user) { FactoryGirl.create(:user) }
        let(:calendar) { FactoryGirl.create(:calendar, user: user) }

        before do
            calendar.save
            sign_in user
            visit user_path(user)
        end

        describe "page" do
            it { should have_link('New Event', href: '#eventModal') }
            it { should have_selector('title', text: "GrebeCalendarApp: " + user.full_name) }
        end

        describe "new event" do
            describe "with invalid information" do
                before do
                    click_button 'Save'
                end

                specify { calendar.events.count == 0 }
            end

            describe "with valid information" do
                before do
                    fill_in "Title", with: "Test Event"
                    fill_in "Date",  with: "02/27/2013"
                    fill_in "Start Time",  with: "10:00 AM"
                    fill_in "End Time",  with: "11:00 AM"
                    click_button 'Save'
                end

                specify { calendar.events.count == 1 }
                it { should have_content('Test Event')}
                it { should have_content('2013-02-27')}
                it { should have_content('10:00 AM to 11:00 AM')}
            end
        end
    end
end
