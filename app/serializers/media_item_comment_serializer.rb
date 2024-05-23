class MediaItemCommentSerializer
  include JSONAPI::Serializer

  attributes :id, :comment
end
