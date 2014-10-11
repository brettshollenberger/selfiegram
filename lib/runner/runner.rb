class Selfiegram
  class Runner
    class << self
      def run(options={})
        options = Options.new(options).to_h

        Selfiegram.send(options[:action], options)
      end

      def root
        File.expand_path(File.join(__FILE__, "../../../"))
      end
    end
  end
end
