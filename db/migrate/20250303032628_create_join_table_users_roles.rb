class CreateJoinTableUsersRoles < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :roles do |t|
      t.index [:user_id, :role_id]
      t.index [:role_id, :user_id]
    end

    add_foreign_key :roles_users, :users
    add_foreign_key :roles_users, :roles

    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :job_title, :string
    add_column :users, :phone_number, :string
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
  end
end
