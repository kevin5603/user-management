# simple controller for users
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show; end

  def new
    @user = User.new
    @available_roles = Role.all if can? :update_user_roles, @user
  end

  def create
    @user = User.new(user_params.except(:roles_ids))
    @user.roles = Role.where(id: user_params[:roles_ids]).to_a
    if @user.save
      redirect_to @user
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_roles = Role.all if can? :update_user_roles, @user
  end

  def update
    if user_params[:password].blank?
      user_params.delete(:password)
      user_params.delete(:password_confirmation)
    end
    success = User.transaction do
      @user.roles = Role.where(id: user_params[:role_ids]).to_a
      @user.update(user_params.except(:role_ids))
    end

    if success
      redirect_to @user, notice: 'User was successfully updated.'
    else
      Rails.logger.error(@user.errors.inspect)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    puts params.inspect
    permits = %i[first_name last_name email job_title phone_number]
    permits.push(:password, :password_confirmation) unless params[:user][:password].blank?
    permits.push(role_ids: []) if can? :update_user_roles, @user
    params.require(:user).permit(permits)
  end
end
