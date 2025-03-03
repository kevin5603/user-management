r1 = Role.create({name: 'Admin'})
r2 = Role.create({name: 'Manager'})
r3 = Role.create({name: 'Regular'})

User.create({first_name:'Genie', last_name: 'Hsu', role_ids: [r1.id], email:'genie@gmail.com', password:'password', password_confirmation:'password', job_title: 'Software Engineer', phone_number: "1234567890"})
User.create({first_name:'Gina', last_name: 'Lin', role_ids: [r2.id], email:'gina@gmail.com', password:'password', password_confirmation:'password', job_title: 'Software Engineer', phone_number: "1234567890"})
User.create({first_name:'Regular', last_name: 'Anonymous', role_ids: [r3.id], email:'regular@gmail.com', password:'password', password_confirmation:'password', job_title: 'Regular', phone_number: "1234567890"})
