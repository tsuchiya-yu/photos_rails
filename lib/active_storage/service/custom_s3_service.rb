require 'active_storage/service/s3_service'

module ActiveStorage
  class Service::CustomS3Service < Service::S3Service
    private

    def object_for(key)
      bucket.object(prefix(key))
    end

    def prefix(key)
      "#{Rails.env}/#{key}"
    end
  end
end
