require 'spec_helper'

describe "SubscriptionPages" do
    subject { page }
  
    let(:user1) { FactoryGirl.create(:user) }
    let(:calendar1) { FactoryGirl.create(:calendar, user: user) }
    let(:calendar2) { FactoryGirl.create(:calendar, user: user, default: false) }
    let(:allday1) { FactoryGirl.create(:all_day, calendar: calendar1) }
    let(:allday2) { FactoryGirl.create(:all_day, calendar: calendar2) }
    let(:event1) { FactoryGirl.create(:event, calendar: calendar1) }
    let(:event2) { FactoryGirl.create(:event, calendar: calendar2) }
    let(:event3) { FactoryGirl.create(:event, title: "Unique", calendar: calendar1) }

    before do
        user.default_view = :list
        user.save
        calendar1.save
        calendar2.save
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
    end

end
