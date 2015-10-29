class Auth::SessionsController < Devise::SessionsController
<% if ajax_login? -%>
  after_action :set_csrf_headers, only: [:create, :destroy]

  respond_to :html, :js
<% end -%>

  # def create
  #   super do |user|
  #     # Custom log-in logic goes here
  #   end
  # end

  # def destroy
  #  # custom before log-out logic
  #   super
  #  # any extra cleaning code, like deleting flash notice
  # end

  def sign_in_and_redirect(resource_or_scope, *args)
    options  = args.extract_options!
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    user = args.last || resource_or_scope

    respond_to do |format|
      format.html { super }
      format.js do
        sign_in(scope, user, options) if warden.user(scope) != user
        redirect_url = after_ajax_sign_in_path_for(user)
        redirect_to redirect_url if redirect_url.present?
      end
    end
  end

<% if ajax_login? -%>
  protected

  def after_ajax_sign_in_path_for(user)
    redirect_url = after_sign_in_path_for(user)
    if redirect_url.present
      redirect_url = "#{redirect_url}.js" if redirect_url[-3..-1] != '.js'
      redirect_url += redirect_url.match(/\?/) ? '&' : '?'
      redirect_url += "after_sign_in=true"
    end
    redirect_url
  end

  def after_sign_in_path_for(user)
    stored_location_for(user) || signed_in_root_path(user)
  end

  def set_csrf_headers
    if request.xhr?
      response.headers['X-CSRF-Token'] = form_authenticity_token.to_s
      response.headers['X-CSRF-Param'] = request_forgery_protection_token.to_s
    end
  end
<% end -%>
end
