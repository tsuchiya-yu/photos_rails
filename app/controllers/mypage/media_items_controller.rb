class Mypage::MediaItemsController < Mypage::MypageApplicationController
  def new
    @album = current_user.albums.find(params[:album_id])
  end
end
