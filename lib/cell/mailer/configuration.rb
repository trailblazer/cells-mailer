module Cell
  module Mailer
    class Configuration
      class << self
        def attributes
          { to: nil, from: nil, subject: nil, mail_options: {} }
        end
      end

      self.attributes.each do |name, value|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}(value = nil)
            store[:#{name}] = value if value
            store[:#{name}]
          end

          def #{name}=(value)
            store[:#{name}] = value
          end
        RUBY
      end

      def initialize(args = {})
        if (wrong_keys = args.keys - self.class.attributes.keys).any?
          raise ArgumentError, "`:#{wrong_keys.first}` is not a valid argument!"
        end

        @store = self.class.attributes.merge(args)
      end

      def clone
        cloned_store = {}
        store.each do |key, value|
          next if [Symbol, TrueClass, FalseClass, NilClass].include? value.class
          cloned_store[key] = value.clone
        end
        self.class.new cloned_store
      end

      private

      attr_reader :store
    end
  end
end
