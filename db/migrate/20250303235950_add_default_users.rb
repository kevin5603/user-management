class AddDefaultUsers < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      direction.up do
        admin = User.create(first_name: "Olivia", last_name: "Sophia", email: "admin@a.com", password: "111111", phone_number: '0912345678', job_title: 'Administration', confirmed_at: Time.now)
        manager = User.create(first_name: "Ethan", last_name: "Lucas", email: "manager@a.com", password: "111111", phone_number: '0987654321', job_title: 'Manager', confirmed_at: Time.now)
        admin.roles << Role.create_or_find_by(name: "admin")
        manager.roles << Role.create_or_find_by(name: "manager")
      end
    end
  end
end
