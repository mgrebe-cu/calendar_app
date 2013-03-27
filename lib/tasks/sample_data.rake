namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_subscriptions
  end
end

def make_users
  admin = User.create!(full_name: "Example User",
                       username:  "exuser",
                       password:  "password1",
                       password_confirmation: "password1")
  admin.toggle!(:admin)
  9.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    full_name  = first_name + last_name
    username = (first_name[0] + last_name).downcase
    password  = "password1"
    user = User.create!(full_name: full_name,
                username:  username,
                password:  password,
                password_confirmation: password)
    make_calendars(user)
  end
end

def make_calendars(user)
  3.times do |i|
    description = Faker::Lorem.sentences(2).join
    title = Faker::Lorem.words(1).join
    color = i
    if i==0
      pub = true
    else
      pub = false
    end
    cal = user.calendars.create(title: title, 
                          description: description,
                          color: color,
                          public: pub)
    make_events(cal)
  end
end

def make_events(calendar)
  50.times do |i|
    title = Faker::Lorem.words(1).join
    location = Faker::Lorem.words(2).join
    start_time = 
    calendar.events.create(title: title,
                           location: location,
                           start_time: ,
                           end_time: )
  end
end

def make_subscriptions

end

