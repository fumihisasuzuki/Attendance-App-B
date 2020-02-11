# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# coding: utf-8

User.create!(name: "管理者",
             email: "sample-1@email.com",
             password: "password",
             password_confirmation: "password",
             employee_number: 1,
             uid: 000001,
             admin: true)

User.create!(name: "上長A",
             email: "sample-2@email.com",
             password: "password",
             password_confirmation: "password",
             employee_number: 2,
             uid: 000002,
             superior: true)

User.create!(name: "上長B",
             email: "sample-3@email.com",
             password: "password",
             password_confirmation: "password",
             employee_number: 3,
             uid: 000003,
             superior: true)

100.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+4}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               employee_number: n+4,
               uid: n+4)
end
