require "RMagick"
require "open-uri"
require "json"
require "fileutils"
require "pry"

class Object
  def eigenclass
    class << self
      self
    end
  end
end

class Selfiegram
  include Actionable
  attr_accessor :action, :user, :magic, :selfiegram_path,
                :output_path, :background_image_path, :image, :verbose

  action :snap
  action :add_user

  def initialize(options={})
    options.each { |key, value| send("#{key}=", value) }
    puts options if verbose
  end

  def snap
    mkdir(background_image_dir)
    download_background_image
    overlay_selfie
    save
  end

  def add_user
    mkdir(selfiegram_dir)
    cp(image, selfiegram_path)
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
    @selfie_image ||= Magick::Image.read(selfiegram_path).first
  end

  def background_image_downloader
    @background_image_downloader ||= BackgroundImages::Downloader.new(magic, background_image_path)
  end

  def download_background_image
    background_image_downloader.download.standardize(selfie_image).clean
  end

  def parent_dir(path)
    components = path.split("/")
    components.pop
    components.join("/")
  end

  def selfiegram_dir
    parent_dir(selfiegram_path)
  end

  def background_image_dir
    parent_dir(background_image_path)
  end

  def cp(origin, destination)
    FileUtils.cp(origin, destination)
  end

  def mkdir(dir)
    FileUtils.mkdir_p(dir)
  end
end

