require 'spec_helper'

describe "SubscriptionPages" do
    subject { page }
  
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user, default_view: :list) }
    let(:calendar1) { FactoryGirl.create(:calendar, user: user1, public: true) }
    let(:calendar2) { FactoryGirl.create(:calendar, user: user1, default: false) }
    let(:calendar3) { FactoryGirl.create(:calendar, user: user2) }
    let(:allday1) { FactoryGirl.create(:all_day, calendar: calendar1) }
    let(:allday2) { FactoryGirl.create(:all_day, calendar: calendar2) }
    let(:allday3) { FactoryGirl.create(:all_day, calendar: calendar3) }
    let(:event1) { FactoryGirl.create(:event, calendar: calendar1) }
    let(:event2) { FactoryGirl.create(:event, calendar: calendar2) }
    let(:event3) { FactoryGirl.create(:event, calendar: calendar3) }

    before do
        user1.save
        user2.save
        calendar1.save
        calendar2.save
        calendar3.save
        allday1.save
        allday2.save
        allday3.save
        event1.save
        event2.save
        event3.save
    end

    describe "subscribe to public" do

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

    describe "subscribe to public" do

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

    describe "subscribe to other calendar"
        before do
            sign_in user1
            
        end

    end
end
