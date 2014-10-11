require "RMagick"
require "open-uri"
require "json"
require "pry"

class Object
  def eigenclass
    class << self
      self
    end
  end
end

class Selfiegram
  attr_accessor :user, :magic, :selfiegram_path, :output_path, :background_image_path

  def initialize(options={})
    options.each { |key, value| send("#{key}=", value) }

    puts user
    puts magic
    puts selfiegram_path
    puts output_path
    puts background_image_path
    # download_background_image
    # overlay_selfie
    # save
  end

  def self.snap(options={})
    new(options)
  end

private
  def save
    background_image.write(output_path)
  end

  def overlay_selfie
    background_image.composite!(selfie_image, 0, 0, Magick::OverCompositeOp)
  end

  def background_image
    @background_image ||= Magick::Image.read(background_image_path).first
  end

  def selfie_image
    @selfie_image ||= Magick::Image.read("selfie_original.png").first
  end

  def background_image_downloader
    @background_image_downloader ||= BackgroundImages::Downloader.new(magic)
  end

  def download_background_image
    background_image_downloader.download.standardize.clean
  end
end

