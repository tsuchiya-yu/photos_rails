class Mypage::GroupMembersController < Mypage::MypageApplicationController

    def index
        @group = Group.find(params[:group_id])
    end

end