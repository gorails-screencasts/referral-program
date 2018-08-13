class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :access_grants, class_name: "Doorkeeper::AccessGrant", foreign_key: :resource_owner_id, dependent: :delete_all # or :destroy if you need callbacks
  has_many :access_tokens, class_name: "Doorkeeper::AccessToken", foreign_key: :resource_owner_id, dependent: :delete_all # or :destroy if you need callbacks
  has_many :notifications, foreign_key: :recipient_id
  has_many :services

  belongs_to :referred_by, class_name: "User", optional: true
  has_many :referred_users, class_name: "User", foreign_key: :referred_by_id

  before_create :set_referral_code
  #after_create :complete_referral!
  validates :referral_code, uniqueness: true

  def set_referral_code
    loop do
      self.referral_code = SecureRandom.hex(6)
      break unless self.class.exists?(referral_code: referral_code)
    end
  end

  # Call this from anywhere in your application when the user has completed their referral steps
  def complete_referral!
    update(referral_completed_at: Time.zone.now)
    # TODO: add credit to referred_by user
  end
end
