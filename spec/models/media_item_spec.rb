require 'rails_helper'

RSpec.describe MediaItem, type: :model do
  let(:group) { create(:group) }
  let(:album) { create(:album, group: group) }
  let(:media_item) { build(:media_item, album: album) }

  describe 'アソシエーション' do
    it { is_expected.to belong_to(:album) }
    it { is_expected.to have_many(:comments).class_name('MediaItemComment').dependent(:destroy) }
  end

  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:media) }
  end

  describe '委譲' do
    it { is_expected.to delegate_method(:group).to(:album) }
  end

  describe 'コールバック' do
    it 'コミット後にサムネイルを生成する' do
      expect(media_item).to receive(:generate_thumbnail)
      media_item.save
    end
  end

  describe '#generate_thumbnail' do
    context 'メディアが画像の場合' do
      before do
        media_double = double(attached?: true, content_type: 'image/jpeg')
        allow(media_double).to receive(:open).and_yield(StringIO.new)
        allow(media_item).to receive(:media).and_return(media_double)
        allow(media_item).to receive(:thumbnail).and_return(double(attached?: false))
        allow(media_item).to receive(:generate_thumbnail)
      end

      it 'サムネイルを添付する' do
        media_item.save
        expect(media_item).to have_received(:generate_thumbnail)
      end
    end

    context 'メディアが動画の場合' do
      before do
        file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_video.mp4'), 'video/mp4')
        media_item.media.attach(file)
        allow(media_item).to receive(:generate_thumbnail)
        allow(media_item).to receive(:save) do
          media_item.generate_thumbnail
          true
        end
        media_item.save
      end

      it 'サムネイルを添付する' do
        expect(media_item).to have_received(:generate_thumbnail)
      end
    end

    context 'メディアが添付されていない場合' do
      before do
        allow(media_item).to receive(:media).and_return(double(attached?: false))
        allow(media_item).to receive(:handle_image_file)
        allow(media_item).to receive(:handle_video_file)
      end

      it 'サムネイルを生成しない' do
        media_item.save
        expect(media_item).to_not have_received(:handle_image_file)
        expect(media_item).to_not have_received(:handle_video_file)
      end
    end
  end

end
