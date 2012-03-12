namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_contacts
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar")
  admin.set_admin!
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_contacts
  users = User.all
  user  = users.first
  contact_users = users[1..50]
  owners      = users[3..40]
  contact_users.each { |contact| user.add_contact!(contact) }
  owners.each      { |owner| owner.add_contact!(user) }
end