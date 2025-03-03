r1 = Role.create({name: 'Admin'})
r2 = Role.create({name: 'Manager'})
r3 = Role.create({name: 'Regular'})

u1 = User.create({first_name:'Genie', last_name: 'Hsu', email:'genie@gmail.com', password:'password', password_confirmation:'password', job_title: 'Software Engineer'})
u2 = User.create({first_name:'Gina', last_name: 'Lin', email:'gina@gmail.com', password:'password', password_confirmation:'password', job_title: 'Software Engineer'})
u3 = User.create({first_name:'Regular', last_name: 'Anonymous', email:'regular@gmail.com', password:'password', password_confirmation:'password', job_title: 'Regular'})

ur1 = UserRole.create(user: u1, role_id: r1.id)
ur2 = UserRole.create(user: u2, role_id: r2.id)
ur3 = UserRole.create(user: u3, role_id: r3.id)