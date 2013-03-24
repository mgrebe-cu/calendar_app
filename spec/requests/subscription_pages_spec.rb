require 'spec_helper'

describe "SubscriptionPages" do
    subject { page }
  
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user, default_view: :list) }
    let(:calendar1) { FactoryGirl.create(:calendar, user: user1, public: true) }
    let(:calendar2) { FactoryGirl.create(:calendar, user: user2) }
    let(:allday1) { FactoryGirl.create(:all_day, calendar: calendar1) }
    let(:allday2) { FactoryGirl.create(:all_day, calendar: calendar2) }
    let(:event1) { FactoryGirl.create(:event, calendar: calendar1) }
    let(:event2) { FactoryGirl.create(:event, calendar: calendar2) }

    before do
        user1.default_view = :day
        user2.default_view = :day
        user1.save
        user2.save
        calendar1.save
        calendar2.save
        allday1.save
        allday2.save
        event1.save
        event2.save
    end

    describe "Subscribe to public" do

        before do
            sign_in user2
            visit user_path(user2)
            find(:xpath, "(//a/i[@class='icon-plus iconlink'])[2]/..").click
            click_button 'Add Subscription'
        end

        it { should have_content('Share1')}
        it { should have_content(allday1.title)}
        it { should have_content(event1.title)}
    end

    describe "Subscribe to non-public" do

        before do
            sub = Subscription.new
            sub.user_id = user1.id
            sub.calendar_id = calendar2.id
            sub.rw = false
            sub.displayed = true
            sub.subscribed = false
            sub.save
            sign_in user1
            visit user_path(user1)
            find(:xpath, "(//a/i[@class='icon-plus iconlink'])[2]/..").click
            click_button 'Add Subscription'
        end

        it { should have_content('Share1')}
        it { should have_content(allday2.title)}
        it { should have_content(event2.title)}
    end

    describe "Share calendar", :js => true do
        before do
            sign_in user2
            find(:xpath, "//i[@class='icon-cogs iconlink']/..").click
            page.has_css?("#calendar_title", :visible => true)
            find(:xpath, "(//i[@class='icon-plus iconlink'])/..").click
            page.has_css?("#subscription_username", :visible => true)
            fill_in "Username", with: user1.username
            within "#share-form" do
                click_button "Save"
            end
            page.has_css?("#calendar_title", :visible => true)
        end

        it { should have_content("View Only")}

        describe "Delete shared calendar" do
            before do
                find(:xpath, "//i[@class='icon-trash iconlink']/..").click
                page.driver.browser.switch_to.alert.accept
            end

            it { should_not have_content("View Only")}
        end

        describe "Change access on shared calendar" do
            before do
                find(:xpath, "//i[@class='icon-edit iconlink']/..").click
            end

            it { should have_content("View and Modify")}
        end

    end
end
