class HomeController < ApplicationController
  authorize_resource class: false
  def index
  end

  def admin
    render "home/admin"
  end

  def manager
    render "home/manager"
  end

  def normal
    render "home/normal"
  end
end
