# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Seeding database"

testgroup = Group.create(name: "Numeration test")

Segment.create(category: "date", format: "Ymd", base_value: Time.now.strftime("%Y-%m-%d"), value: Time.now.strftime("%Y-%m-%d"), behavior: "system", reset: "never", position: 2, group: testgroup)

Segment.create(category: "alpha", base_value: "AAA", value: "AAA", behavior: "correlative", reset: "day", position: 1, group: testgroup)


Group.create(name: "Test 2")

Segment.create(category: "alpha", base_value: "1A", value: "1A", behavior: "correlative", reset: "month", position: 1, group_id: 2)

Segment.create(category: "date", format: "mYd", base_value: Time.now.strftime("%Y-%m-%d"), value: Time.now.strftime("%Y-%m-%d"), behavior: "system", reset: "never", position: 2, group_id: 2)

Segment.create(category: "alpha", base_value: "22", value: "22", behavior: "correlative", reset: "day", position: 3, group_id: 2)


Group.create(name: "Test 3")

Segment.create(category: "alpha", base_value: "00", value: "00", behavior: "correlative", reset: "never", position: 1, group_id: 3)

puts "Database seeded"