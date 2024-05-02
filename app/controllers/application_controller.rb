class ApplicationController < ActionController::Base
  protected

  # ユーザーがログイン後にリダイレクトされるパス
  def after_sign_in_path_for(resource)
    mypage_path
  end
end
