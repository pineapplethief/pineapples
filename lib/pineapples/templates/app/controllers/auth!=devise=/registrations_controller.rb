class Auth::RegistrationsController < Devise::RegistrationsController

<% if ajax_login? -%>
  respond_to :html, :js

<% end -%>
  # def create
  #   super do |user|
  #     # Custom create logic goes here
  #   end
  # end

  def sign_up_params
    params.permit(:email,
                  :password,
                  :password_confirmation)
  end

  def account_update_params
    params.permit(:email,
                  :password,
                  :password_confirmation,
                  :current_password)
  end

end
