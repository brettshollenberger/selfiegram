class Selfiegram
  class Runner
    class << self
      def run(options={})
        Selfiegram.snap Options.new(options)
      end

      def root
        File.expand_path(File.join(__FILE__, "../../../"))
      end
    end
  end
end
