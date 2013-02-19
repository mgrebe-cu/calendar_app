FactoryGirl.define do
    factory :user do
        sequence(:full_name)  { |n| "Person #{n}" }
        sequence(:username) { |n| "person_#{n}"}   
        password "foo1bar"
        password_confirmation "foo1bar"
    end

end