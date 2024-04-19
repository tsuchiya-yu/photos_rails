class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :trackable,
          :omniauthable, omniauth_providers: [:line]

  has_many :groups, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.find_or_create_from_line(auth_info)
    user = User.find_by(uid: auth_info.uid, provider: auth_info.provider)

    unless user
      email = auth_info.info.email || "user_#{auth_info.uid}@example.com" # 適当なメアド(現状使わないので)
      user = User.new(
        email: email,
        uid: auth_info.uid,
        provider: auth_info.provider,
        name: auth_info.info.name,
        password: Devise.friendly_token[0,20] # ランダム値(現状使わないので)
      )
      user.save
    end
    user
  end

end