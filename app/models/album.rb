class Album < ApplicationRecord
  belongs_to :group
  has_many :users, through: :group
  has_many :media_items, dependent: :destroy
end
