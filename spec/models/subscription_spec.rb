require 'spec_helper'

describe Subscription do

    let(:user) { FactoryGirl.create(:user) }
    let(:calendar) { FactoryGirl.create(:calendar) }
    let(:subscription) { user.subscriptions.build(calendar_id: calendar.id, rw: false) }

    subject { subscription }

    it { should be_valid }

    it { should respond_to(:user_id) }
    it { should respond_to(:calendar_id) }
    it { should respond_to(:color) }
    it { should respond_to(:subscribed) }
    it { should respond_to(:rw) }
    it { should respond_to(:displayed) }
    it { should respond_to(:title) }
    it { should_not be_subscribed}
    it { should_not be_rw}
    it { should be_displayed}

    describe "when user id is not present" do
        before { subscription.user_id = nil }
        it { should_not be_valid }
    end

    describe "when calendar id is not present" do
        before { subscription.calendar_id = nil }
        it { should_not be_valid }
    end

 end
