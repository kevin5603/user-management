class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy]
  authorize_resource class: false
  include UsersHelper

  def index
    @users = User.all
  end

  def edit
    puts @user.inspect
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "User updated successfully."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully."
  end

  def show
    res = @user.to_json(include: {roles: {only: [:name]}})
    puts res
    render json: res
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :phone_number, :job_title)
  end

end
