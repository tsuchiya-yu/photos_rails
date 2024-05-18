class MediaItemSerializer
  include JSONAPI::Serializer

  attributes :album_id, :description, :media

  attribute :filename do |object|
    object.media.filename.to_s if object.media.attached?
  end

  attribute :thumbnail_url do |object|
    Rails.application.routes.url_helpers.rails_blob_path(object.thumbnail, only_path: true) if object.thumbnail.attached?
  end

  attribute :id do |object|
    object.id
  end
end
