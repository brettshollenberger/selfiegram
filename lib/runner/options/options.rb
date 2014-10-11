class Selfiegram
  class Runner
    class Options
      include Enumerable
      attr_accessor :user, :magic, :selfiegram_path, :output_path,
                    :background_image_path, :action, :image, :verbose

      def initialize(options={})
        @user                  = pathify options[:user]
        @magic                 = options[:magic]  || ""
        @action                = options[:action] || :snap
        @image                 = options[:image]
        @verbose               = options[:verbose]
        @selfiegram_path       = options[:path]   || default_selfiegram_path
        @output_path           = default_output_path(options[:output])
        @background_image_path = default_background_image_path
      end

      def to_h
        instance_variables.inject({}) do |hash, var_name|
          getter       = var_name.to_s[1..-1].to_sym
          hash[getter] = send(getter)
          hash
        end
      end

      def each(&block)
        to_h.each(&block)
      end

    private
      def default_selfiegram_path
        absolute_path "selfies/people/#{user}.png"
      end

      def default_output_path(output_path)
        output_path ||= Runner.root
        File.expand_path(File.join(output_path, "tmp/#{magic_path}/final.png"))
      end

      def default_background_image_path
        File.expand_path(File.join("#{output_path}", "../background.png"))
      end

      def magic_path
        pathify(magic)
      end

      def pathify(string)
        string.split(" ").join("_").downcase
      end

      def absolute_path(relative_path)
        File.expand_path(File.join(Runner.root, relative_path))
      end
    end
  end
end
