require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  # TODO: test

  # ----------------------------------------
  # Not sign in
  # ----------------------------------------

  test 'not signed in user should redirect to login' do
  end

  # ----------------------------------------
  # Regular user
  # ----------------------------------------
  test 'regular user should not get index' do

  end

  test 'regular user should edit self' do
    
  end
  
  test 'regular user should not edit role' do
    
  end
  
  test 'regular user should not edit others' do
    
  end

  # ----------------------------------------
  # Manager
  # ----------------------------------------
  test 'manger should get index' do

  end

  test 'manger should not edit' do

  end
  # ----------------------------------------
  # Admin
  # ----------------------------------------


  test 'admin should get index' do

  end

  test 'admin should edit any user' do

  end

end
