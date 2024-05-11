class Mypage::MediaItemsController < Mypage::MypageApplicationController
  def new
    @album = current_user.albums.find(params[:album_id])
  end

  def show
    @media_item = current_user.media_items.includes(comments: :user).find(params[:id])
  end
end
