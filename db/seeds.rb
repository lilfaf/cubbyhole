# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Plan.create!(name: 'free',
             price: 0,
             max_storage_space: 1024,
             max_bandwidth_up: 100,
             max_bandwidth_down: 500,
             daily_shared_links_quota: 50)

Plan.create!(name: 'silver',
             price: 10,
             max_storage_space: 10240,
             max_bandwidth_up: 300,
             max_bandwidth_down: 1000,
             daily_shared_links_quota: 500)

Plan.create!(name: 'gold',
             price: 15,
             max_storage_space: 102400,
             max_bandwidth_up: 1000,
             max_bandwidth_down: 1000,
             daily_shared_links_quota: 1000)

Plan.create!(name: 'platinium',
             price: 20,
             # 0 = unlimited
             max_storage_space: 0,
             max_bandwidth_up: 0,
             max_bandwidth_down: 0,
             daily_shared_links_quota: 0)

User.create!(username: 'member',
             email: 'member@example.com',
             password: '12345678',
             password_confirmation: '12345678')
User.create!(username: 'admin',
             email: 'admin@example.com',
             password: '12345678',
             password_confirmation: '12345678',
             admin: true)

Doorkeeper::Application.create!(name: 'web')
