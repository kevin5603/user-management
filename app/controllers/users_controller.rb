class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_roles, only: %i[show edit update]
  load_and_authorize_resource

  def index
    @users = User.all
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

  def get_roles
    @roles = Role.all
  end


  private
  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone_number, :job_title, role_ids: [])
  end

end
