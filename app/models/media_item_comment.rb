class MediaItemComment < ApplicationRecord
  belongs_to :user
  belongs_to :media_item

  validates :user_id, presence: true
  validates :media_item_id, presence: true
  validates :comment, presence: true
end
