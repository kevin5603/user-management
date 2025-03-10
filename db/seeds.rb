# Ensuring that the User and Role models exist and the database is migrated before running seed

# Create roles
admin_role = Role.create!(name: 'admin')
manager_role = Role.create!(name: 'manager')
user_role = Role.create!(name: 'user')

# Create admin user
admin = User.create!(
  first_name: 'Gina',
  last_name: 'Lin',
  email: 'ginalin@example.com',
  job_title: 'Administrator',
  phone_number: '+1234567890',
  password: 'Admin@123',
  password_confirmation: 'Admin@123'
)
admin.roles << admin_role

# Create manager user
manager = User.create!(
  first_name: 'Jane',
  last_name: 'Smith',
  email: 'manager@example.com',
  job_title: 'Project Manager',
  phone_number: '+1987654321',
  password: 'Manager@123',
  password_confirmation: 'Manager@123'
)
manager.roles << manager_role

# Create regular user
user = User.create!(
  first_name: "User",
  last_name: "Test",
  email: "user1@example.com",
  job_title: "Employee",
  phone_number: "+1000000000",
  password: "User@123",
  password_confirmation: "User@123"
)
user.roles << user_role

puts "Regular user created!"

puts 'Database seeded successfully!'