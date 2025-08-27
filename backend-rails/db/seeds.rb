# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

tasks = <<-TEXT
Buy groceries
Schedule dentist appointment
Call mom
Finish quarterly report
Water the plants
Pick up dry cleaning
Review meeting notes
Update resume
Plan weekend trip
Fix leaky faucet
Submit expense report
Book flight tickets
Organize desk drawer
Reply to client emails
Walk the dog
Backup computer files
Renew gym membership
Prepare presentation slides
Clean out garage
Pay monthly bills
TEXT

tasks.split("\n").each do |name|
  Task.create(name: name)
end