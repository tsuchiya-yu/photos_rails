class Group < ApplicationRecord
  has_many :group_members, dependent: :destroy
  has_many :albums, dependent: :destroy

  validates :name, presence: true
end
