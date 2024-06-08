class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :trackable,
          :omniauthable, omniauth_providers: [:line]

  has_many :group_members, dependent: :destroy
  has_many :groups, through: :group_members
  has_many :albums, through: :groups
  has_many :media_items, through: :albums
  has_many :media_item_comments, dependent: :destroy

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.find_or_create_from_line(auth_info)
    user = User.find_by(uid: auth_info.uid, provider: auth_info.provider)

    unless user
      email = auth_info.info.email || "user_#{auth_info.uid}@example.com" # 適当なメアドを入れておく
      user = User.new(
        email: email,
        uid: auth_info.uid,
        provider: auth_info.provider,
        name: auth_info.info.name,
        password: Devise.friendly_token[0, 20] # ランダム値(現状使わないので)
      )
      user.save
    end
    user
  end

  # このグループのマスター？
  def this_group_master?(group_id)
    return false if group_id.blank?
    group_members.where(group_id: group_id, is_master: true).exists?
  end

  # ダミーのメールアドレス？
  def dummy_email?
    email.start_with?('user_') && email.end_with?('@example.com')
  end

end
