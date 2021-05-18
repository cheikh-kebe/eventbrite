# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

User.destroy_all
Event.destroy_all
Attendance.destroy_all

10.times do
  user = User.create!(
    first_name: Faker::Name.first_name, 
    last_name: Faker::Name.last_name, 
    description: Faker::Quotes::Shakespeare.hamlet_quote, 
    email: "test#{rand(1..100)}@yopmail.com"
  ) 
end

10.times do
  event = Event.create(
    start_date: Faker::Date.forward(days: 23),
    duration: Faker::Number.within(range:1..10)*5, 
    title: Faker::Lorem.sentence,
    description: Faker::Lorem.sentence,
    price: Faker::Number.within(range:1..500),
    location: Faker::Address.city,
    admin_id: Faker::Number.within(range:1..10)
  )
end

10.times do
  attendance = Attendance.create!(
    stripe_customer_id: Faker::Number.within(range:1..100000000),
    guest_id: Faker::Number.within(range:1..10),
    event_id: Faker::Number.within(range:1..10)
  )
end