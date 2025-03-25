class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def index
    if current_user.admin? || current_user.manager?
      @users = User.all
    else
      @users = User.where(id: current_user.id)
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  private
  def user_params
    permitted = [:first_name, :last_name, :email, :job_title, :phone_number, :password, :password_confirmation]

    if can? :manage, User
      permitted << { role_ids: [] } unless params[:id] == current_user.id.to_s
    end

    params.require(:user).permit(permitted)
  end
end
