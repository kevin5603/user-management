class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check
  def access_denied
    @previous_url = request.referer
  end
end