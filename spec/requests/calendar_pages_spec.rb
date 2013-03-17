require 'spec_helper'

describe "CalendarPages" do
    subject { page }
  
    let(:user) { FactoryGirl.create(:user) }
    let(:calendar1) { FactoryGirl.create(:calendar, user: user) }
    let(:calendar2) { FactoryGirl.create(:calendar, user: user, 
                        default: false, color: :red) }
    let(:calendar3) { FactoryGirl.create(:calendar, user: user, 
                        default: false, displayed: false, color: :yellow) }
    let(:allday1) { FactoryGirl.create(:all_day, calendar: calendar1) }
    let(:allday2) { FactoryGirl.create(:all_day, calendar: calendar2) }
    let(:event1) { FactoryGirl.create(:event, calendar: calendar1) }
    let(:event2) { FactoryGirl.create(:event, calendar: calendar2) }
    let(:event3) { FactoryGirl.create(:event, title: "Unique", calendar: calendar1) }
    let(:event4) { FactoryGirl.create(:event, calendar: calendar3)}

    before do
        user.default_view = :day
        user.save
        calendar1.save
        calendar2.save
        calendar3.save
        allday1.save
        allday2.save
        event1.save
        event2.save
        event3.save
        event4.save
        sign_in user
    end

    describe "home" do

        before do
            visit user_path(user)
        end

        describe "new calendar" do
            describe "with invalid information", :js => true do
                before do
                    find(:xpath, "//a/i[@class='icon-plus iconlink']/..").click
                    find_modal_element("#calendar_title")
                    click_button 'Save'
                end
                it { should have_content('Title is required')}
                specify { user.calendars.count == 2 }
            end

            describe "with valid information", :js => true do
                before do
                    find(:xpath, "//a/i[@class='icon-plus iconlink']/..").click
                    fill_in "calendar[title]", with: "Test Calendar"
                    fill_in "calendar[description]",  with: "Testing"
                    select 'Green', from: 'calendar[color]'
                    click_button 'Save'
                    visit user_path(user)
                end

                specify { user.calendars.count == 3 }
                it { should have_content('Test Calendar')}

            end
        end

        describe "edit calendar", :js => true do
            before do
                find(:xpath, "(//a/i[@class='icon-cogs iconlink'])[2]/..").click
                find_modal_element("#calendar_title")
                fill_in "calendar[title]", with: "Edited Calendar"
                select 'Green', from: 'calendar[color]'
                click_button 'Save'
            end
            it { should have_xpath("//i[@class='icon-circle calf_green']")}
            it { should have_content('Edited Calendar')}
        end

        describe "delete calendar", :js => true do
            before do
                find(:xpath, "(//a/i[@class='icon-cogs iconlink'])[2]/..").click
                find_modal_element("#calendar_title")
                click_link 'Delete'
            end
            
            specify { user.calendars.count == 1 }
            it { should_not have_content(calendar2.title)}
        end

        describe "new shared calendar" do
            before do
                find(:xpath, "(//a/i[@class='icon-plus iconlink'])[2]/..").click
            end

            it { should have_content("Subscribe to a Calendar")}
        end
    end

    describe "month" do
        before do
            visit user_path(user)
            click_link "Month"
        end

        describe "todays page" do
           it { should have_xpath("//a/div/i[@class='icon-circle calf_blue']")}
           it { should have_xpath("//a/div/i[@class='icon-circle calf_red']")}
           it { should_not have_xpath("//a/div/i[@class='icon-circle calf_yello']")}
        end

        describe "disable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check iconlink']/..").click
            end
           
            it { should_not have_xpath("//a/div/i[@class='icon-circle calf_blue']")}
        end

        describe "enable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check-empty iconlink']/..").click
            end
           
            it { should have_xpath("//a/div/i[@class='icon-circle calf_yellow']")}
        end
    end 

    describe "week" do
        before do
            visit user_path(user)
            click_link "Week"
        end

        describe "todays page" do
           it { should have_xpath("//td[@class='day_appointment calb_blue']")}
           it { should have_xpath("//td[@class='day_appointment calb_red']")}
           it { should_not have_xpath("//td[@class='day_appointment calb_yellow']")}
        end

        describe "disable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check iconlink']/..").click
            end
           
           it { should_not have_xpath("//td[@class='day_appointment calb_yellow']")}
        end

        describe "enable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check-empty iconlink']/..").click
            end
           
           it { should have_xpath("//td[@class='day_appointment calb_yellow']")}
        end
    end 

    describe "day" do
        before do
            visit user_path(user)
            click_link "Day"
        end

        describe "todays page" do
           it { should have_xpath("//td[@class='day_appointment calb_blue']")}
           it { should have_xpath("//td[@class='day_appointment calb_red']")}
           it { should_not have_xpath("//td[@class='day_appointment calb_yellow']")}
        end

        describe "disable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check iconlink']/..").click
            end
           
           it { should_not have_xpath("//td[@class='day_appointment calb_yellow']")}
        end

        describe "enable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check-empty iconlink']/..").click
            end
           
           it { should have_xpath("//td[@class='day_appointment calb_yellow']")}
        end
    end 

    describe "list" do
        before do
            visit user_path(user)
            click_link "List"
        end

        describe "eventss page" do
           it { should have_xpath("//td[@class='day_appointment calb_blue']")}
           it { should have_xpath("//td[@class='day_appointment calb_red']")}
           it { should_not have_xpath("//td[@class='day_appointment calb_yellow']")}
        end

        describe "disable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check iconlink']/..").click
            end
           
           it { should_not have_xpath("//td[@class='day_appointment calb_yellow']")}
        end

        describe "enable calendar" do
            before do
                find(:xpath, "//a/i[@class='icon-check-empty iconlink']/..").click
            end
           
           it { should have_xpath("//td[@class='day_appointment calb_yellow']")}
        end
    end 

end
