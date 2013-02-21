require 'spec_helper'

describe Event do

    let(:calendar) { FactoryGirl.create(:calendar)}
    before do
        @event = calendar.events.build(all_day: false, date: "11-09-2001",
                        start: "10:00", end: "11:00", location: 'Home',
                        notes: nil)
    end

    subject(@event)

    it { should respond_to(:all_day) }
    it { should respond_to(:date) }
    it { should respond_to(:start) }
    it { should respond_to(:end) }
    it { should respond_to(:location) }
    it { should respond_to(:notes) }
    it { should respond_to(:calendar_id) }

    it { should be_valid }

    describe "when calendar id is not present" do
        before { @event.calendar_id = nil }
        it { should_not be_valid }
    end

    describe "when not all day and end & start not present" do
        before do
            @event.start == nil
            @event.end == nil
        end
        it { should_not be_valid }
    end

    describe "when not all day and end < start" do
        before do
            @event.start == "10:00"
            @event.end == "9:00"
        end
        it { should_not be_valid }
    end
end
