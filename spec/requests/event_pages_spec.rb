require 'spec_helper'

describe "EventPages" do
    subject { page }
  
    let(:user) { FactoryGirl.create(:user) }
    let(:calendar) { FactoryGirl.create(:calendar, user: user) }
    let(:allday1) { FactoryGirl.create(:all_day, calendar: calendar) }
    let(:allday2) { FactoryGirl.create(:all_day, calendar: calendar) }
    let(:event1) { FactoryGirl.create(:event, calendar: calendar) }
    let(:event2) { FactoryGirl.create(:event, calendar: calendar) }
    let(:event3) { FactoryGirl.create(:event, title: "Unique", calendar: calendar) }

    before do
        user.default_view = :list
        user.save
        calendar.save
        allday1.save
        allday2.save
        event1.save
        event2.save
        event3.save
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
                    click_link 'New Event'
                    click_button 'Save'
                end
                #it { should have_content('Title is required')}
                specify { calendar.events.count == 0 }
            end

            describe "with valid information" do
                before do
                    click_link 'New Event'
                    fill_in "Title", with: "Test Event"
                    fill_in "Start Date",  with: "03/27/2013"
                    fill_in "End Date",  with: "03/27/2013"
                    fill_in "Start Time",  with: "10:00 AM"
                    fill_in "End Time",  with: "11:00 AM"
                    click_button 'Save'
                end

                specify { calendar.events.count == 1 }
                it { should have_content('Test Event')}
                it { should have_content('03/27/2013')}
                it { should have_content('10:00 AM')}
                it { should have_content('11:00 AM')}

            end
        end

        describe "edit event", :js => true do
            before do
                click_link 'Test Event'
                find_modal_element("#event_title")
                fill_in "event[title]", with: "Edited Event"
                click_button 'Save'
            end
            
            it { should have_content('Edited Event')}
        end

        describe "delete event", :js => true do
            before do
                click_link 'Unique'
                find_modal_element("#event_title")
                click_link 'Delete'
            end
            
            #specify { calendar.events.count == 0 }
            it { should_not have_content('Unique')}
        end
    end

    describe "month" do
        before do
            visit user_path(user)
            click_link "Month"
        end

        describe "todays page" do
            time = Time.now
            heading = time.strftime("%B %Y")
            it { should have_content(heading) }
            it { should have_content(event2.title)}
            it { should have_content(event3.title)}
            it { should have_content('3 more')}
        end
    end 

    describe "week" do
        before do
            visit user_path(user)
            click_link "Week"
        end

        describe "todays page" do
            time = Time.now
            heading = time.strftime("%B %-d")
            it { should have_content(event1.title)}
            it { should have_content(event2.title)}
            it { should have_content(allday1.title)}
            it { should have_content(allday2.title)}
        end
    end 

    describe "day" do
        before do
            visit user_path(user)
            click_link "Day"
        end

        describe "todays page" do
            time = Time.now
            it { should have_content(event1.title)}
            it { should have_content(event2.title)}
            it { should have_content(allday1.title)}
            it { should have_content(allday2.title)}
         end
    end 

end
