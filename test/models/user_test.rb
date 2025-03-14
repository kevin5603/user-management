require 'test_helper'
require 'sidekiq/testing'

class UserTest < ActiveSupport::TestCase

  def setup
    Sidekiq::Testing.fake!
    Sidekiq::Job.clear_all

    @valid_user_param = {
      email: 'foo.bar@example.com',
      password: 'password',
      first_name: 'Foo',
      last_name: 'Bar',
      phone_number: '0912345678',
    }
  end

  test 'should be able create valid user' do
    assert User.create!(@valid_user_param)
  end

  test 'should not allow invalid phone numbers' do
    user = User.new(@valid_user_param)

    user.phone_number = '123456'
    assert_not user.valid?
  end

  test 'should able to have multiple roles' do
    user = User.create!(@valid_user_param)
    user.roles << Role.new(name: 'role_foo')
    user.roles << Role.new(name: 'role_bar')
    user.reload
    assert_equal user.roles.count, 2
  end

  test 'email should be unique' do
    User.create!(@valid_user_param)
    user = User.new(@valid_user_param)
    assert_not user.valid?
  end

  test 'should enqueue email job when create new user' do
    assert_equal 0, RegistrationNotificationEmailJob.jobs.size
    User.create!(@valid_user_param)
    assert_equal 1, RegistrationNotificationEmailJob.jobs.size
  end

end
