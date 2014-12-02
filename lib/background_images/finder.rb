module BackgroundImages
  class  Finder
    attr_accessor :find_image_of, :max_attempts, :results

    def initialize(find_image_of = "Brad Pitt's Ghost")
      @find_image_of             = find_image_of
      @max_attempts              = 3
    end

    def find_many(attempt=1)
      return results unless results.nil?

       if attempt > @max_attempts
         raise "Unable to get response from Google Image search"
       end

       response = JSON.parse(find_command)

       return find_many(attempt+1) unless valid_image_search_response?(response)

       results = response["responseData"]["results"]

       if results.empty?
         raise "Unable to get response from Google Image search"
       end

       return results
    end

    def find_one(method=:first)
      result = find_many.send(method)
      return find_one if result.nil?
      return result
    end

  private
    def valid_image_search_response?(response)
      response.is_a?(Hash) && response.has_key?("responseData") && response["responseData"].is_a?(Hash) && response["responseData"].has_key?("results")
    end

    def find_command
      `curl "#{find_url}"`
    end

    def find_url
      "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=#{encode(find_image_of)}"
    end

    def encode(query_string="")
      URI::encode(query_string)
    end
  end
end
