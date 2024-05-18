require 'rails_helper'

RSpec.describe MediaItemSerializer, type: :serializer do
  describe 'シリアライゼーション' do
    let(:album) { create(:album) }
    let(:media_item) { build(:media_item, album: album) }
    let(:serializer) { MediaItemSerializer.new(media_item) }
    let(:serialization) { JSON.parse(serializer.serializable_hash.to_json) }

    before do
      allow(Rails.application.routes.url_helpers).to receive(:rails_blob_path).and_return('/path/to/thumbnail')
      allow_any_instance_of(ActiveStorage::Attached::One).to receive(:attached?).and_return(true)

      # 添付ファイルの設定
      media_item.media.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg')),
        filename: 'test_image.jpg',
        content_type: 'image/jpg'
      )

      media_item.thumbnail.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image_thumb.jpg')),
        filename: 'test_image_thumb.v',
        content_type: 'image/jpg'
      )
    end

    it '期待される属性が含まれていること' do
      expect(serialization['data']['attributes']).to include(
        'album_id' => media_item.album_id,
        'description' => media_item.description,
        'filename' => 'test_image.jpg',
        'thumbnail_url' => Rails.application.routes.url_helpers.rails_blob_path(media_item.thumbnail, only_path: true),
        'id' => media_item.id
      )
    end

    it 'media属性が含まれていること' do
      expect(serialization['data']['attributes']).to include('media')
    end
  end
end
