FactoryGirl.define do
    factory :user do
        sequence(:full_name)  { |n| "Person #{n}" }
        sequence(:username) { |n| "person_#{n}"}   
        password "foo1bar"
        password_confirmation "foo1bar"
        time_zone "Central Time (US & Canada)"
    end

    factory :calendar do
        default true
        sequence(:title) { |n| "Calendar #{n}"}
        sequence(:description) { |n| "Calendar for tracking #{n} things"}
        sequence (:color) { |n| :blue }
        # sequence(:color) do |n|
        #     colors = [:blue, :red, :orange, :yellow, green:, purple:, brown:]
        #     colors[n%7]
        # end
        user
    end

    factory :event do
        sequence(:title) { |n| "Test Event #{n}"}
        sequence(:location) { |n| "Location #{n}"}
        sequence(:notes) { |n| "Notes about #{n}"}
        all_day false
        start_date Time.now
        end_date Time.now
        start_time 3.hour.ago
        end_time 1.hour.ago
        calendar
    end

    factory :all_day, :class => Event do
        sequence(:title) { |n| "All Event #{100+n}"}
        sequence(:location) { |n| "Location #{n}"}
        sequence(:notes) { |n| "Notes about #{n}"}
        start_date Time.now
        end_date Time.now
        all_day true
        start_time Time.now
        end_time Time.now
        calendar
    end

end