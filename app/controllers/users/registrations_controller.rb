class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    super
    if resource.persisted?
      AdminNotificationJob.perform_async(@user.id)
    end
  end

end
