require "RMagick"
require "open-uri"
require "json"

class Selfiegram
  attr_accessor :take_with

  def initialize(take_with="Brad Pitt's Ghost")
    @take_with = take_with
  end

  def snap
    download_background_image
    overlay_selfie
    save
  end

private
  def save
    background_image.write("final.png")
  end

  def overlay_selfie
    background_image.composite!(selfie_image, 0, 0, Magick::OverCompositeOp)
  end

  def background_image
    @background_image ||= Magick::Image.read("source_original.png").first
  end

  def selfie_image
    @selfie_image ||= Magick::Image.read("selfie_original.png").first
  end

  def background_image_downloader
    @background_image_downloader ||= BackgroundImages::Downloader.new(@take_with)
  end

  def download_background_image
    background_image_downloader.download.standardize.clean
  end
end

