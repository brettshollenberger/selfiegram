module BackgroundImages
  class Downloader
    attr_accessor :find_image_of, :file_extension, :download_url

    def initialize(find_image_of="Brad Pitt's Ghost")
      @find_image_of = find_image_of
    end

    def download
      `curl "#{download_url}" > "#{local_file}.#{file_extension}"`
      self
    end

    def standardize
      `convert #{local_file}.#{file_extension} -resize '866x561^' -gravity 'center' -crop '866x561+0+0' #{local_file}.#{destination_extension}`

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
      "source_original"
    end

    def destination_extension
      "png"
    end

    def acceptable_extensions
      ["jpg", "png", "gif"]
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
