class Mypage::GroupsController < Mypage::MypageApplicationController
  def new
    @group = Group.new
  end

  def create
    group = Group.new(group_params)
    if group.save && group.group_members.create(user: current_user, is_master: true)
      redirect_to mypage_path, notice: 'グループを作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @group = current_user.groups.includes(albums: :media_items).find(params[:id])
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update(group_params)
      redirect_to mypage_group_path(@group), notice: '更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def confirm_destroy
    @group = current_user.groups.find(params[:id])
    redirect_to mypage_group_path(@group), alert: 'オーナーのみが可能な操作です' unless current_user.this_group_master?(@group.id)
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    redirect_to mypage_group_path(@group), alert: 'オーナーのみが可能な操作です' unless current_user.this_group_master?(@group.id)
    @group.destroy!
    redirect_to mypage_path, notice: 'グループを削除しました'
  end

  private

  def group_params
    params.require(:group).permit(:name, :catchphrase)
  end
end
