require 'spec_helper'

describe Calendar do
    let(:user) { FactoryGirl.create(:user) }
    
    before do
        @calendar = user.calendars.build(default: true,
                        title: "Calendar 1", description: "Stuff for 1 items",
                        color: :blue, displayed: true)
    end

    subject( @calendar )

    it { should respond_to(:default) }
    it { should respond_to(:user_id) }
    it { should respond_to(:title) }
    it { should respond_to(:description) }
    it { should respond_to(:color) }
    it { should respond_to(:displayed) }

    it { should be_displayed }
    it { should_not be_public }

    specify { @calendar.valid? }

    describe "when user id is not present" do
        before { @calendar.user_id = nil }
        it { should_not be_valid }
    end

    describe "when title is not present" do
        before { @calendar.title = nil }
        it { should_not be_valid }
    end

    describe "when color is not present" do
        before { @calendar.color = nil }
        it { should_not be_valid }
    end

    describe "when displayed is not present" do
        before { @calendar.displayed = nil }
        it { should_not be_valid }
    end

    describe "when title is already taken" do
        before do
            calendar_with_same_title = @calendar.dup
            calendar_with_same_title.save
        end

        it { should_not be_valid}
    end
end
