class Mypage::MypageApplicationController < ApplicationController
    before_action :debug_login
    before_action :check_login

    # デバッグのためのログイン
    # TODO: 不要になったら消す
    def debug_login
        return unless Rails.env.development?
        user = User.first
        sign_in(user)
    end

    def check_login
        # ログインしていない場合はログインページにリダイレクト
        redirect_to new_user_session_path unless user_signed_in?
    end

end
