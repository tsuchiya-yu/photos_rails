require 'rails_helper'

RSpec.describe Api::V1::MediaItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:album) { create(:album, group: group) }

  before do
    create(:group_member, group: group, user: user)
    sign_in user
  end

  describe 'POST #create' do
    let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_image.jpg'), 'image/png') }

    context '有効なパラメータの場合' do
      it '新しいメディアアイテムを作成し、ステータス201を返すこと' do
        post :create, params: { album_id: album.id, media_item: { media: [file] } }
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['data'].first['attributes']['filename']).to eq('test_image.jpg')
      end
    end

    context '無効なパラメータの場合' do
      it 'ステータス422を返すこと' do
        post :create, params: { album_id: album.id, media_item: { media: [] } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'パラメータが存在しない場合、ステータス422を返すこと' do
        post :create, params: { album_id: album.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:media_item) { create(:media_item, album: album) }

    context 'メディアアイテムが存在する場合' do
      it 'メディアアイテムを削除し、ステータス201を返すこと' do
        delete :destroy, params: { album_id: album.id, id: media_item.id }
        expect(response).to have_http_status(:created)
        expect { media_item.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'メディアアイテムが存在しない場合' do
      it 'ステータス422を返すこと' do
        delete :destroy, params: { album_id: album.id, id: 9999 } # 存在しないID
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
