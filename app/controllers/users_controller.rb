class UsersController < ApplicationController

  before_action :authenticate_user!
  before_action :set_user, only: %i[show]

  def index
    @users = User.all
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

end
