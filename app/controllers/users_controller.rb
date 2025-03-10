# simple controller for users
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show; end

  def new
    # TODO: keep the new here aside from registration.new aka /user/sign_up, for admin's add user page
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  # TODO: do I really need registration.edit?
  def edit
    @available_roles = Role.all if can? :update_user_roles, @user
  end

  def update
    success = User.transaction do
      @user.roles = Role.where(id: user_params[:role_ids]).to_a if user_params[:role_ids]
      # TODO: add edit permission permission
      @user.update(user_params.except(:role_ids))
    end

    if success
      redirect_to @user, notice: 'User was successfully updated.'
    else
      Rails.logger.error(@user.errors.inspect)
      render :edit, status: :unprocessable_entity
    end
  end

  # TODO: add destroy

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # TODO: feels wired to use cancancan ability this way. maybe I should create another endpoint call user_roles?
    basic_permits = %i[first_name last_name email job_title phone_number]
    basic_permits.push(role_ids: []) if can? :update_user_roles, @user
    params.require(:user).permit(basic_permits)
  end
end
