require "test_helper"

class RoleTest < ActiveSupport::TestCase

  def setup
    Role.destroy_all # todo somehow this is not cleaning the data
    @role = Role.create!(name: "admin")
  end

  test "should be valid with a name" do
    assert @role.valid?
  end

  test "name should be present" do
    @role.name = ""
    assert_not @role.valid?
    assert_includes @role.errors[:name], "can't be blank"
  end

  test "name should be unique" do
    Role.destroy_all
    Role.create!(name: "admin")

    duplicate_role = Role.new(name: "admin")

    assert_not duplicate_role.valid?
    assert_includes duplicate_role.errors[:name], "has already been taken"
  end

  test "can have many users through user_roles" do
    user1 = User.create!(
      first_name: "John",
      last_name: "Doe",
      email: "user1@example.com",
      phone_number: "+1 234 567 8901",
      password: "password123",
      password_confirmation: "password123"
    )

    user2 = User.create!(
      first_name: "Jane",
      last_name: "Smith",
      email: "user2@example.com",
      phone_number: "+1 234 567 8901",
      password: "password123",
      password_confirmation: "password123"
    )

    @role.save!
    user1.roles << @role
    user2.roles << @role

    assert_includes @role.users, user1
    assert_includes @role.users, user2
  end
end
