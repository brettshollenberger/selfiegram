class Selfiegram
  module Actionable
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      def action(name)
        define_singleton_method "#{name}" do |options|
          new(options).send(name)
        end
      end
    end
  end
end
