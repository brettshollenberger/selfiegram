class Selfiegram
  class Runner
    class Options
      include Enumerable
      attr_accessor :user, :magic, :selfiegram_path, :output_path, :background_image_path

      def initialize(options={})
        @user                  = options[:user]
        @magic                 = options[:magic]
        @selfiegram_path       = options[:path]        || default_selfiegram_path
        @output_path           = options[:output_path] || default_output_path
        @background_image_path = "#{output_path}/background.png"
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
        absolute_path "selfies/people/#{user}"
      end

      def default_output_path
        absolute_path "tmp/#{magic_path}"
      end

      def magic_path
        magic.split(" ").join("_").downcase
      end

      def absolute_path(relative_path)
        File.expand_path(File.join(Runner.root, relative_path))
      end
    end
  end
end
