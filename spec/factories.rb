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
        public false
        user
    end

    factory :event do
        sequence(:title) { |n| "#{n} Test"}
        sequence(:location) { |n| "Location #{n}"}
        sequence(:notes) { |n| "Notes about #{n}"}
        all_day false
        start_date Time.zone.now
        end_date Time.zone.now
        sequence(:start_time) { |n| Time.zone.now.midnight + (9+n%8).hours }
        sequence(:end_time) { |n| Time.zone.now.midnight + (9+n%8).hours + 
                                ((n%4 + 1) * 30).minutes }
        calendar
    end

    factory :all_day, :class => Event do
        sequence(:title) { |n| "#{n} All"}
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