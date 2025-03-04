class ModifyDefaultUserRole < ActiveRecord::Migration[6.1]
  def change
    reversible do |direction|
      direction.up do
        execute "UPDATE roles_users SET role_id = 2 WHERE user_id = 1"
        execute "UPDATE roles_users SET role_id = 3 WHERE user_id = 2"
      end
      direction.down do
        execute "UPDATE roles_users SET role_id = 1 WHERE user_id = 1"
        execute "UPDATE roles_users SET role_id = 1 WHERE user_id = 2"
      end
    end
  end
end
