FactoryBot.define do
  factory :media_item do
    album
    media { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/test_image.jpg'), 'image/jpeg') }
  end
end
