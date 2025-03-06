class CreateJoinTableUsersRoles < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :roles do |t|
      t.index [:user_id, :role_id]
      t.index [:role_id, :user_id]
    end

    add_foreign_key :roles_users, :users
    add_foreign_key :roles_users, :roles
  end
end
