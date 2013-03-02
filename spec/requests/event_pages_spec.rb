require 'spec_helper'

describe "EventPages" do
    subject { page }

    let(:user) { FactoryGirl.create(:user) }
    let(:calendar) { FactoryGirl.create(:calendar, user: user) }

    before do
        user.default_view = :list
        user.save
        calendar.save
        sign_in user
    end

    describe "home" do

        before do
            visit user_path(user)
        end

        describe "page" do
            it { should have_link('New Event', href: '#eventModal') }
            it { should have_link('Month') }
            it { should have_link('Week') }
            it { should have_link('Day') }
            it { should have_link('List') }
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
                    fill_in "Start Date",  with: "02/27/2013"
                    fill_in "End Date",  with: "02/27/2013"
                    fill_in "Start Time",  with: "10:00 AM"
                    fill_in "End Time",  with: "11:00 AM"
                    click_button 'Save'
                end

                specify { calendar.events.count == 1 }
                it { should have_content('Test Event')}
                it { should have_content('2013-02-27')}
                it { should have_content('10:00 AM to 11:00 AM')}

                describe "delete event" do
                    before do
                        click_link 'delete'
                    end
                    
                    specify { calendar.events.count == 0 }
                    it { should_not have_content('Test Event')}
                end
            end
        end
    end

    describe "month" do
        before do
            click_link "Month"
        end

        describe "page" do
            time = Time.now
            heading = time.strftime("%B %Y")
            it { should have_content(heading) }
        end
    end 

end
