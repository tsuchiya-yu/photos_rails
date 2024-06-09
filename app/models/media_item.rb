class MediaItem < ApplicationRecord
  belongs_to :album
  delegate :group, to: :album
  has_many :comments, class_name: 'MediaItemComment', dependent: :destroy

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
      strip_exif_data(file.path) # EXIF情報を削除
      resize_and_attach_thumbnail(file)
    end
  end

  def handle_video_file
    media.open(tmpdir: Rails.root.join('tmp')) do |file|
      generate_video_thumbnail(file)
      convert_to_mp4(file)
    end
  end

  def resize_and_attach_thumbnail(file)
    resized_image = ImageProcessing::MiniMagick
      .source(file)
      .resize_to_fill(280, 280, gravity: 'Center')
      .call

    thumbnail.attach(
      io: File.open(resized_image.path),
      filename: "thumb_#{media.filename}",
      content_type: 'image/jpeg' # サムネイルはJPEG形式で統一
    )
  end

  def generate_video_thumbnail(file)
    require 'streamio-ffmpeg'
    require 'image_processing/mini_magick'

    movie = FFMPEG::Movie.new(file.path)
    screenshot_path = "#{Rails.root.join('tmp')}/screenshot.jpg"
    movie.screenshot(screenshot_path, { seek_time: 1 })

    processed_image_path = ImageProcessing::MiniMagick
      .source(screenshot_path)
      .resize_to_fill(280, 280, gravity: 'Center')
      .call

    thumbnail.attach(
      io: File.open(processed_image_path),
      filename: "thumb_#{media.filename}.jpg",
      content_type: 'image/jpeg'
    )
  end

  def convert_to_mp4(file)
    require 'streamio-ffmpeg'

    movie = FFMPEG::Movie.new(file.path)
    mp4_path = "#{Rails.root.join('tmp')}/#{media.filename.base}.mp4"
    options = { video_codec: 'libx264', custom: %w(-crf 23 -preset ultrafast) }
    movie.transcode(mp4_path, options)

    media.attach(
      io: File.open(mp4_path),
      filename: "#{media.filename.base}.mp4",
      content_type: 'video/mp4'
    )
  end

  def strip_exif_data(image_path)
    require 'mini_magick'

    image = MiniMagick::Image.open(image_path)
    image.strip
    image.write(image_path)
  end
end
