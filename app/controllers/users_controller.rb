class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @users = User.accessible_by(current_ability)
  end

  def new
    authorize! :create, User  # Only admins can create users
    @user = User.new
  end

  def create
    # Remove or modify this line if you want admins to create users
    # authorize! :create, User  # Only admins can create users

    @user = User.new(user_params)

    # Explicitly check if current user is admin instead of using authorize!
    if current_user&.roles&.exists?(name: "admin")
      if @user.save
        redirect_to @user, notice: 'User was successfully created.'
      else
        render :new
      end
    else
      redirect_to root_path, alert: 'Not authorized to create users.'
    end
  end

  def update
    authorize! :update, @user  # Only admins can update users
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
        authorize! :destroy, @user  # Only admins can delete users
    @user.destroy
    redirect_to users_url, notice: 'User was successfully destroyed.'
  end

  def show
  end

  def edit
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    permitted = [:first_name, :last_name, :email, :job_title, :phone_number, :password, :password_confirmation]

    if current_user&.roles&.exists?(name: "admin")
      permitted << { role_ids: [] } unless params[:id] == current_user.id.to_s
    end

    params.require(:user).permit(permitted)
  end
end
