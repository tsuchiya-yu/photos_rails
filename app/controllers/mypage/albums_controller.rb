class Mypage::AlbumsController < Mypage::MypageApplicationController
  def new
    @album = current_user.groups.find(params[:group_id]).albums.new
  end

  def create
    album = current_user.groups.find(params[:group_id]).albums.new(album_params)
    if album.save
      redirect_to mypage_group_album_path(group_id: album.group.id, id: album.id), notice: 'アルバムを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @album = current_user.albums.
      includes(media_items: { thumbnail_attachment: :blob }).
      find(params[:id])
    @media_items = @album.media_items.includes(thumbnail_attachment: :blob, media_attachment: :blob).order(id: :desc)
  end

  def confirm_destroy
    @album = current_user.albums.find(params[:id])
    unless current_user.this_group_master?(@album.group.id)
      redirect_to mypage_group_album_path(group_id: @album.group.id, id: @album.id),
alert: 'オーナーのみが可能な操作です'
    end
  end

  def edit
    @album = current_user.albums.find(params[:id])
  end

  def update
    @album = current_user.albums.find(params[:id])
    if @album.update(album_params)
      redirect_to mypage_group_album_path(group_id: @album.group.id, id: @album.id), notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @album = current_user.albums.find(params[:id])
    unless current_user.this_group_master?(@album.group.id)
      redirect_to mypage_group_album_path(group_id: @album.group.id, id: @album.id),
alert: 'オーナーのみが可能な操作です'
    end
    @album.destroy!
    redirect_to mypage_group_path(id: @album.group.id), notice: 'アルバムを削除しました'
  end

  private

  def album_params
    params.require(:album).permit(:name, :catchphrase)
  end
end
