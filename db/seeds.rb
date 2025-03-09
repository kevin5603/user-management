# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin_role = Role.find_or_create_by(name: 'admin', description: 'administer with full permission')
manager_role = Role.find_or_create_by(name: 'manager', description: 'manager with view all permission')

index_users = Permission.find_or_create_by(name: 'index', description: 'List all the users')
show_users = Permission.find_or_create_by(name: 'show', description: 'View any user')
new_users = Permission.find_or_create_by(name: 'new', description: 'Displays the form to create new users')
create_users = Permission.find_or_create_by(name: 'create', description: 'Create a new user')
edit_users = Permission.find_or_create_by(name: 'edit', description: 'Displays the form to edit users')
update_users = Permission.find_or_create_by(name: 'update', description: 'Update users')
destroy_users = Permission.find_or_create_by(name: 'destroy', description: 'Delete the user')

admin_role.permissions.clear
admin_role.permissions.push(index_users, show_users, new_users, create_users, edit_users, update_users, destroy_users)
manager_role.permissions.clear
manager_role.permissions.push(index_users, show_users)

# create default admin
admin_user = User.find_by(email: 'admin@example.com')
if admin_user.nil?
  admin_user = User.create!(
    first_name: 'default',
    last_name: 'admin',
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
end
admin_user.roles << admin_role unless admin_user.roles.include?(admin_role)

# create default manager
manger_user = User.find_by(email: 'manager@example.com')
if manger_user.nil?
  manager_user = User.create!(
    first_name: 'default',
    last_name: 'manager',
    email: 'manager@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
end
manager_user.roles << manager_role unless manager_user.roles.include?(manager_role)

unless User.find_by(email: 'user@example.com')
  User.create!(
    first_name: 'default',
    last_name: 'user',
    email: 'user@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
end
