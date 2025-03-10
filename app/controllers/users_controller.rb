class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  include UsersHelper

  def index
    @users = User.all
  end

  def edit
    @roles = Role.all
  end

  def update
    if @user.update(user_params)
      @user.roles = Role.where(id: params[:user][:role_ids])
      redirect_to users_path, notice: "User updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully."
  end

  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone_number, :job_title, role_ids: [])
  end

end
