module BackgroundImages
  class Downloader
    attr_accessor :find_image_of, :save_to_file, :file_extension, :download_url

    def initialize(find_image_of="Brad Pitt's Ghost", save_to_file="")
      @find_image_of = find_image_of
      @save_to_file  = save_to_file
    end

    def download
      `curl "#{download_url}" > "#{local_file}.#{file_extension}"`
      self
    end

    def standardize(selfie_image)
      dimensions = "#{selfie_image.page.width}x#{selfie_image.page.height}"

      `convert #{local_file}.#{file_extension} -resize '#{dimensions}^' -gravity 'center' -crop '#{dimensions}+0+0' #{local_file}.#{destination_extension}`

      if command_failed?
        get_new_background_image
        download
        standardize
      end

      self
    end

    def clean
      `find . -type f -name "*.png" -exec convert {} -strip {} \;`
    end

  private
    def command_failed?
      $? != 0
    end

    def local_file
      save_to_file.split(".")[0..-2].join(".")
    end

    def destination_extension
      save_to_file.split(".")[-1] || "png"
    end

    def acceptable_extensions
      ["jpg", "png"]
    end

    def acceptable_extension?(extension)
      acceptable_extensions.include?(extension.to_s)
    end

    def file_extension(file=download_url)
      file.split(".").last
    end

    def download_url
      @download_url ||= find_image
    end

    def find_image(method=:first)
      image = image_finder.find_one(method)

      unless acceptable_extension? file_extension(image["url"])
        return find_image(:sample)
      end

      image["url"]
    end

    def image_finder
      @image_finder ||= BackgroundImages::Finder.new(find_image_of)
    end

    # Randomly select a new background image
    def get_new_background_image
      @download_url = find_image(:sample)
    end
  end
end
