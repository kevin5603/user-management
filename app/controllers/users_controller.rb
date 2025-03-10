class UsersController < ApplicationController
  # Ensure only authenticated users can access except for new and create
  before_action :authenticate_user!, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # Devise handles password encryption, so we use its sign-in method
      sign_in(@user) if user_signed_in? == false
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

  def show
  end

  def edit
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    # Let Devise handle password encryption, so we permit only the required attributes
    params.require(:user).permit(:first_name, :last_name, :email, :job_title, :phone_number, :password, :password_confirmation)
  end
end
