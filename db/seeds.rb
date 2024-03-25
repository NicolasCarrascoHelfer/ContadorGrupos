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

fecha = Segment.create(s_type: "FECHA", format: "YYYYMMDD", base_value: ".", value: ".", behavior: "SISTEMA", reset: "NUNCA", order: 1, group: testgroup)

fecha.update(base_value: fecha.created_at.strftime("%Y%m%d"), value: fecha.created_at.strftime("%Y%m%d"))

Segment.create(s_type: "ALFANUMERICO", format: nil, base_value: "AAA", value: "AAA", behavior: "CORRELATIVO", reset: "DIA", order: 2, group: testgroup)

puts "Database seeded"
