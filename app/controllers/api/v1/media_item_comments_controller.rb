class Api::V1::MediaItemCommentsController < ApplicationController
  def create
    @media_item = current_user.media_items.find(params[:media_item_id])
    @comment = @media_item.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:media_item_comment).permit(:comment)
  end
end
