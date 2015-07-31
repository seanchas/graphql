require_relative './attribute_definition'

module GraphQL
  module GraphQLTypeConfiguration

    def self.included(base)
      base.extend(ClassMethods)
    end

    def valid?
      @configuration.class.defined_attributes.all? do |name|
        @configuration.send(:"#{name}?")
      end
    end

    def method_missing(name, *args, &block)
      if @configuration.respond_to?(name)
        @configuration.send(name, *args, &block)
      else
        super
      end
    end


    class Base
      extend GraphQL::GraphQLTypeAttributeDefinition

      def initialize(options = {})
        extend(options)
      end

      def extend(options = {})
        options.each { |key, value| send(key, value) }
        self
      end
    end


    module ClassMethods

      def configuration(configuration_class = nil)
        @configuration_class = configuration_class if configuration_class && configuration_class <= Base
        @configuration_class ||= Class.new(Base)
      end

      def attribute(*args, &block)
        self.configuration.attribute(*args, &block)
      end

      def new(*args, &block)
        configuration   = args.first if args.first.is_a?(self.configuration)
        options         = args.last.is_a?(::Hash) ? args.last : {}

        if configuration
          super(configuration.extend(options))
        else
          configuration = self.configuration.new(options)
          configuration.instance_eval(&block) if block_given?
          super(configuration)
        end
      end

    end

  end
end
