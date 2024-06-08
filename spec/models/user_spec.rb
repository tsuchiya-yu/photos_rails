require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'アソシエーション' do
    it 'group_membersを持っており、削除時に依存関係にあるものも削除される' do
      should have_many(:group_members).dependent(:destroy)
    end

    it 'groupsを持っている（group_membersを通じて）' do
      should have_many(:groups).through(:group_members)
    end

    it 'albumsを持っている（groupsを通じて）' do
      should have_many(:albums).through(:groups)
    end

    it 'media_itemsを持っている（albumsを通じて）' do
      should have_many(:media_items).through(:albums)
    end

    it 'media_item_commentsを持っており、削除時に依存関係にあるものも削除される' do
      should have_many(:media_item_comments).dependent(:destroy)
    end
  end

  describe 'バリデーション' do
    it 'メールアドレスが存在すること' do
      should validate_presence_of(:email)
    end

    it 'メールアドレスが一意であること（大文字小文字を区別しない）' do
      should validate_uniqueness_of(:email).case_insensitive
    end
  end

  describe '.from_omniauth' do
    let(:auth) { OmniAuth::AuthHash.new(provider: 'line', uid: '123456', info: { email: 'test@example.com' }) }

    it 'ユーザーが存在しない場合、新しいユーザーを作成する' do
      expect do
        User.from_omniauth(auth)
      end.to change { User.count }.by(1)
    end

    it '既存のユーザーが存在する場合、そのユーザーを返す' do
      user = User.from_omniauth(auth)
      expect(User.from_omniauth(auth)).to eq(user)
    end

    it '新しいユーザーにメールアドレスとパスワードを設定する' do
      user = User.from_omniauth(auth)
      expect(user.email).to eq('test@example.com')
      expect(user.encrypted_password).to be_present
    end
  end

  describe '.find_or_create_from_line' do
    let(:auth_info) do
      OmniAuth::AuthHash.new(provider: 'line', uid: '123456', info: { email: 'test@example.com', name: 'Test User' })
    end

    it 'ユーザーが存在しない場合、新しいユーザーを作成する' do
      expect do
        User.find_or_create_from_line(auth_info)
      end.to change { User.count }.by(1)
    end

    it '既存のユーザーが存在する場合、そのユーザーを返す' do
      user = User.find_or_create_from_line(auth_info)
      expect(User.find_or_create_from_line(auth_info)).to eq(user)
    end

    it '新しいユーザーにメールアドレス、UID、プロバイダー、名前、パスワードを設定する' do
      user = User.find_or_create_from_line(auth_info)
      expect(user.email).to eq('test@example.com')
      expect(user.uid).to eq('123456')
      expect(user.provider).to eq('line')
      expect(user.name).to eq('Test User')
      expect(user.encrypted_password).to be_present
    end

    it 'メールアドレスが提供されない場合、デフォルトのメールアドレスを設定する' do
      auth_info.info.email = nil
      user = User.find_or_create_from_line(auth_info)
      expect(user.email).to eq("user_#{auth_info.uid}@example.com")
    end
  end

  describe '.this_group_master?' do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    context 'group_idが空の場合' do
      it 'falseを返す' do
        expect(user.this_group_master?('')).to be false
      end
    end

    context 'ユーザーがグループのマスターである場合' do
      before do
        create(:group_member, user: user, group: group, is_master: true)
      end

      it 'trueを返す' do
        expect(user.this_group_master?(group.id)).to be true
      end
    end

    context 'ユーザーがグループのマスターでない場合' do
      before do
        create(:group_member, user: user, group: group, is_master: false)
      end

      it 'falseを返す' do
        expect(user.this_group_master?(group.id)).to be false
      end
    end
  end

  describe 'ダミーメールアドレス判定' do
    let(:user) { User.new(email: email) }

    context 'メールアドレスがuser_で始まり@example.comで終わる場合' do
      let(:email) { 'user_123@example.com' }

      it 'trueを返す' do
        expect(user.dummy_email?).to be true
      end
    end

    context 'メールアドレスがuser_で始まらない場合' do
      let(:email) { 'test_user_123@example.com' }

      it 'falseを返す' do
        expect(user.dummy_email?).to be false
      end
    end

    context 'メールアドレスが@example.comで終わらない場合' do
      let(:email) { 'user_123@sample.com' }

      it 'falseを返す' do
        expect(user.dummy_email?).to be false
      end
    end

    context 'メールアドレスがuser_で始まらず@example.comで終わらない場合' do
      let(:email) { 'test_user_123@sample.com' }

      it 'falseを返す' do
        expect(user.dummy_email?).to be false
      end
    end
  end

end
