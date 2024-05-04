class MediaItem < ApplicationRecord
  belongs_to :album
  has_one_attached :media
  has_one_attached :thumbnail

  validates :media, presence: true

  after_commit :generate_thumbnail, on: [:create, :update]

  def generate_thumbnail
    return unless media.attached?
    return if thumbnail.attached?

    if media.content_type.start_with?('image/')
      handle_image_file
    elsif media.content_type.start_with?('video/')
      handle_video_file
    end
  end

  private

  def handle_image_file
    media.open(tmpdir: Rails.root.join('tmp')) do |file|
      resize_and_attach_thumbnail(file)
    end
  end

  def handle_video_file
    media.open(tmpdir: Rails.root.join('tmp')) do |file|
      generate_video_thumbnail(file)
    end
  end

  def resize_and_attach_thumbnail(file)
    resized_image = ImageProcessing::MiniMagick
                      .source(file)
                      .resize_to_fill(280, 280, gravity: 'Center')
                      .call
  
    thumbnail.attach(
      io: File.open(resized_image.path),
      filename: "thumb_#{media.filename.to_s}",  # `media.filename.to_s` でメディアのオリジナル名を保持
      content_type: 'image/jpeg'  # サムネイルはJPEG形式で統一
    )
  end

  def generate_video_thumbnail(file)
    require 'streamio-ffmpeg'
    require 'image_processing/mini_magick'
  
    movie = FFMPEG::Movie.new(file.path)
    screenshot_path = "#{Rails.root.join('tmp')}/screenshot.jpg"
    movie.screenshot(screenshot_path, { seek_time: 10 })
  
    processed_image_path = ImageProcessing::MiniMagick
                            .source(screenshot_path)
                            .resize_to_fill(280, 280, gravity: 'Center')
                            .call
  
    thumbnail.attach(
      io: File.open(processed_image_path),
      filename: "thumb_#{media.filename.to_s}.jpg",  # `media.filename.to_s` を使用
      content_type: 'image/jpeg'
    )
  end

end
