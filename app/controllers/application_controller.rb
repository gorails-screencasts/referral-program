class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_referral_cookie

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end

    def set_referral_cookie
      if params[:ref]
        cookies[:referral_code] = {
          value: params[:ref],
          expires: 30.days.from_now,
        }
      end
    end
end
