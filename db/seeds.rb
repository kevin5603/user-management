admin_role = Role.create({name: 'Admin'})
manager_role = Role.create({name: 'Manager'})
regular_role = Role.create({name: 'Regular'})

User.create({first_name:'Genie', last_name: 'Hsu', role_ids: [admin_role.id], email:'genie@gmail.com', password:'password', password_confirmation:'password', job_title: 'Software Engineer', phone_number: "1234567890"})
User.create({first_name:'Gina', last_name: 'Lin', role_ids: [manager_role.id], email:'gina@gmail.com', password:'password', password_confirmation:'password', job_title: 'Software Engineer', phone_number: "1234567890"})
User.create({first_name:'Regular', last_name: 'Anonymous', role_ids: [regular_role.id], email:'regular@gmail.com', password:'password', password_confirmation:'password', job_title: 'Regular', phone_number: "1234567890"})
