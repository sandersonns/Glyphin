# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Ensure the table is empty to avoid creating duplicate entries when you run the seeds multiple times.
User.delete_all

# Create users
User.find_or_create_by!(email: 'jane.doe@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.username = 'janedoe'
  user.first_name = 'Jane'
  user.last_name = 'Doe'
  user.bio = 'Lover of coffee and coding.'
  user.default_glyph_privacy = 0
end

User.find_or_create_by!(email: 'john.smith@example.com') do |user|
  user.password = 'securepassword!'
  user.password_confirmation = 'securepassword!'
  user.username = 'johnsmith'
  user.first_name = 'John'
  user.last_name = 'Smith'
  user.bio = 'Avid reader and tech enthusiast.'
  user.default_glyph_privacy = 0
end

User.find_or_create_by!(email: 'alice.wonderland@example.com') do |user|
  user.password = 'wonderland123'
  user.password_confirmation = 'wonderland123'
  user.username = 'alicewonderland'
  user.first_name = 'Alice'
  user.last_name = 'Wonderland'
  user.bio = 'Exploring digital worlds.'
  user.default_glyph_privacy = 0
end

puts "Users created!"