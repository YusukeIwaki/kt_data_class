require "kt_data_class/base"

module KtDataClass
  class InvalidDefinitionError < ArgumentError ; end

  class Factory
    def initialize(definition)
      raise_if_invalid(definition)
      @definition = definition.dup
    end

    def create
      member_definition = @definition
      Class.new(Base) do
        define_singleton_method(:definition) do
          member_definition
        end
        attr_reader(*member_definition.keys)
      end
    end

    private

    def raise_if_invalid(definition)
      unless definition.is_a?(Hash)
        raise InvalidDefinitionError.new("class definition must be specified with Hash")
      end
      definition.each do |attr_name, klass|
        unless attr_name.is_a?(Symbol)
          raise InvalidDefinitionError.new("attribute name must be a symbol. #{attr_name.class.name} is given: #{attr_name}")
        end
        unless klass.is_a?(Class)
          raise InvalidDefinitionError.new("#{attr_name} is not a class")
        end
      end

      nil
    end
  end
end
