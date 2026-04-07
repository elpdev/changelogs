# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
user = User.find_or_create_by(email_address: "admin@example.com") do |u|
  u.password = "abc123"
  u.admin = true
end

puts "Admin user created: admin@example.com / abc123" if user.previously_new_record?

# Create default project
project = Project.find_or_create_by(github_url: "https://github.com/elpdev/changelogs") do |p|
  p.name = "Changelogs"
  p.description = "Track changelogs for open source projects"
  p.language = "Ruby"
end

puts "Project created: #{project.name} (#{project.slug})" if project.previously_new_record?
