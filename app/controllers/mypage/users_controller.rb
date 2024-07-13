class Mypage::UsersController < Mypage::MypageApplicationController
  def edit
    # ダミーのメアドが設定されている場合は編集画面で表示しない
    current_user.email = '' if current_user.dummy_email?
  end

  def update
    if current_user.update(user_params)
      redirect_to mypage_path, notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end

end
