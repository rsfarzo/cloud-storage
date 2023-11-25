class ApplicationController < ActionController::Base
  #skip_forgery_protection
  protect_from_forgery with: :exception, prepend: true

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

      def configure_permitted_parameters
            devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :password, :token)}

            devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :password, :current_password)}
      end
end
