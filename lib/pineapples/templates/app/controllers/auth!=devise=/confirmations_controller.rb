class Auth::ConfirmationsController < Devise::ConfirmationsController

  # most often it's needed to customize url where to redirect user after confirmation

  # protected

  # def after_confirmation_path_for(resource_name, user)
  #   edit_user_registration_path
  # end

end
