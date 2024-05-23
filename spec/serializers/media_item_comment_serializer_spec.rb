require 'rails_helper'

RSpec.describe MediaItemCommentSerializer, type: :serializer do
  describe 'シリアライゼーション' do
    let(:user) { create(:user) }
    let(:media_item) { create(:media_item) }
    let(:comment) { create(:media_item_comment, user: user, media_item: media_item) }
    let(:serializer) { MediaItemCommentSerializer.new(comment) }
    let(:serialization) { JSON.parse(serializer.serializable_hash.to_json) }

    it '期待通りにシリアライゼーションされること' do
      expect(serialization).to eq(
        "data" => {
          "attributes" => {
            "comment" => comment.comment,
            "id" => comment.id,
          },
          "id" => comment.id.to_s,
          "type" => "media_item_comment",
        }
      )
    end
  end
end
