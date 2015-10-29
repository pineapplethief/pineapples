class Auth::ConfirmationsController < Devise::ConfirmationsController

  # most often it's needed to customize url of location to redirect user to after confirmation

  # protected

  # def after_confirmation_path_for(resource_name, user)
  #   edit_user_registration_path
  # end

end
