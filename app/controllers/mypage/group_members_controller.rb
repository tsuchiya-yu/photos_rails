class Mypage::GroupMembersController < Mypage::MypageApplicationController
  include Encryption

  def index
    @group = current_user.groups.find(params[:group_id])
  end

  def add
    encrypted_gid = params[:id]
    decrypted_gid = Encryption.decrypt(encrypted_gid)

    return redirect_to mypage_group_path(id: group.id), notice: 'URLに誤りがあります' if params[:group_id] != decrypted_gid

    # 参加済みの場合はリダイレクト
    group = Group.find(params[:group_id])
    exists = group.group_members.exists?(user_id: current_user.id)
    return redirect_to mypage_group_path(id: group.id), notice: 'すでに参加しています' if exists

    # グループメンバーに参加
    group.group_members.create(user: current_user, is_master: false)
    redirect_to mypage_group_path(id: @group.id), notice: '参加しました'
  end
end
