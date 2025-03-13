class ErrorsController < ApplicationController
  def access_denied
    @previous_url = request.referer
  end
end