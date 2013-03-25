namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_calendars
    make_events
    make_subscriptions
  end
end

def make_users
  admin = User.create!(full_name: "Example User",
                       username:  "exuser",
                       password:  "foobar1",
                       password_confirmation: "foobar1")
  admin.toggle!(:admin)
  99.times do |n|
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    full_name  = first_name + last_name
    username = (first_name[0] + last_name).downcase
    password  = "password1"
    User.create!(full_name: full_name,
                 username:  username,
                 password:  password,
                 password_confirmation: password)
  end
end

def make_calendars

end

def make_events

end

def make_subscriptions

end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all
  user  = users.first
  followed_users = users[2..50]
  followers      = users[3..40]
  followed_users.each { |followed| user.follow!(followed) }
  followers.each      { |follower| follower.follow!(user) }
end