# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             admin: true)
             
@testuser = User.create!(name: "上長A",
             email: "sample-a@email.com",
             password: "password",
             password_confirmation: "password",
             admin: false,
             superior: true)
if @testuser
    puts "Superior1 User Sucess."
end

@testuser = User.create!(name: "上長B",
             email: "sample-b@email.com",
             password: "password",
             password_confirmation: "password",
             admin: false,
             superior: true)
if @testuser
    puts "Superior2 User Sucess."
end 


60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end



