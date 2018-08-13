class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = {})
    super

    if cookies[:referral_code] && referrer = User.find_by(referral_code: cookies[:referral_code])
      self.resource.referred_by = referrer
    end
  end
end
