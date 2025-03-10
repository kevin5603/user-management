# simple controller for users
class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show; end

  def new
    # todo: keep the new here aside from registration.new aka /user/sign_up, for admin's add user page
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
    @user = User.find(params[:id])
    @roles = Role.all
  end

  def update
    @user = User.find(params[:id])
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

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :job_title, :phone_number, role_ids: [])
  end
end
