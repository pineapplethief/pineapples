class Auth::PasswordsController < Devise::PasswordsController
<% if ajax_login? -%>
  respond_to :html, :js
<% end -%>

  # protected

  # def after_resetting_password_path_for(user)
  #   signed_in_root_path(user)
  # end

end
