require 'spec_helper'

describe Event do

    let(:calendar) { FactoryGirl.create(:calendar)}
    before do
        @event = calendar.events.build(title: 'New Event',
                        all_day: false, 
                        start_time: "11-09-2001 10:00".to_time(:local), 
                        end_time: "11-09-2001 11:00".to_time(:local), 
                        location: 'Home',
                        notes: nil)
        @event.save
    end

    subject(@event)

    it { should respond_to(:title) }
    it { should respond_to(:all_day) }
    it { should respond_to(:start_time) }
    it { should respond_to(:end_time) }
    it { should respond_to(:start_date) }
    it { should respond_to(:end_date) }
    it { should respond_to(:location) }
    it { should respond_to(:notes) }
    it { should respond_to(:calendar_id) }

    specify { @event.valid? }

    describe "when calendar id is not present" do
        before { @event.calendar_id = nil }
        it { should_not be_valid }
    end

    describe "when title is not present" do
        before { @event.title = nil }
        it { should_not be_valid }
    end

    describe "when not all day and end & start not present" do
        before do
            @event.start_time = nil
            @event.end_time = nil
        end
        it { should_not be_valid }
    end

    describe "when not all day and end < start" do
        before do
            @event.start_time = "11-09-2001 10:00".to_time(:local)
            @event.end_time = "11-09-2001 9:00".to_time(:local)
        end
        it { should_not be_valid }
    end
end
