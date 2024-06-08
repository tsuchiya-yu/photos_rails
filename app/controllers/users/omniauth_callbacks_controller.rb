class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def line
    user = User.find_or_create_from_line(auth)

    if user.persisted?
      # ユーザーがデータベースに存在している場合
      if user.dummy_email?
        sign_in user, event: :authentication
        redirect_to edit_mypage_users_path, alert: "安全にご利用いただくためメールアドレスの登録をお願いします。"
      else
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: "LINE") if is_navigational_format?
      end
    else
      # ユーザーが保存できなかった場合
      session["devise.line_data"] = auth.except("extra")
      redirect_to new_user_registration_url, alert: "ユーザーアカウントの作成に失敗しました: #{user.errors.full_messages.to_sentence}"
    end
  end

  private

  def auth
    request.env["omniauth.auth"]
  end
end
