class Api::V1::MediaItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    album = current_user.albums.find(params[:album_id])
    media_items = []

    if params[:media_item].blank? || params[:media_item][:media].blank?
      render json: { error: 'ファイルが選択されていません' }, status: :unprocessable_entity
      return
    end

    params[:media_item][:media].each do |file|
      media_item = album.media_items.new(media: file)

      unless media_item.save
        render json: media_item.errors, status: :unprocessable_entity
        return
      end

      media_items << media_item
    end

    render json: MediaItemSerializer.new(media_items).serializable_hash.to_json, status: :created
  end

  def destroy
    media_item = current_user.media_items.find(params[:id])

    if media_item.destroy
      render json: MediaItemSerializer.new(media_item).serializable_hash.to_json, status: :created
    else
      render json: media_item.errors, status: :unprocessable_entity
    end
  end

  private

  def media_item_params
    params.require(:media_item).permit(media: [])
  end

  def record_not_found
    render json: { error: 'データが存在しません' }, status: :unprocessable_entity
  end
end
