class Api::V1::MediaItemsController < ApplicationController
  def create
    @album = current_user.albums.find(params[:album_id])
    params[:media_item][:media].each do |file|
      @media_item = @album.media_items.new(media: file)

      unless @media_item.save
        render json: @media_item.errors, status: :unprocessable_entity
        return
      end
    end

    if @media_item.save
      render json: @media_item, status: :created
    else
      render json: @media_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    media_item = current_user.media_items.find(params[:id])

    if media_item.destroy
      render json: media_item, status: :created
    else
      # TODO: resourceで返却したい。
      render json: media_item.errors, status: :unprocessable_entity
    end
  end

  private

  # Strong Parametersを修正
  def media_item_params
    params.require(:media_item).permit(media: [])
  end
end
