require 'spec_helper'

describe Calendar do
    let(:user) { FactoryGirl.create(:user) }
    
    before do
        @calendar = user.calendars.build(default: true)
    end

    subject(@calendar)

    it { should respond_to(:default) }
    it { should respond_to(:user_id) }

    it { should be_valid }

    describe "when user id is not present" do
        before { @calendar.user_id = nil }
        it { should_not be_valid }
    end
end
