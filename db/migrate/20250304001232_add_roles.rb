class AddRoles < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      direction.up do
        Role.create(name: "admin")
        Role.create(name: "manager")
      end
    end
  end
end
