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
        user
    end

    factory :event do
        sequence(:title) { |n| "Event #{n}"}
        sequence(:location) { |n| generate(:random_string)}
        sequence(:notes) { |n| LoremIpsum.generate }
        start_time 3.hour.ago
        end_time 1.hour.ago
        calendar
    end
end