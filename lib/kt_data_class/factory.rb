require "kt_data_class/base"
require "kt_data_class/union_syntax"

module KtDataClass
  class InvalidDefinitionError < ArgumentError ; end

  class Factory
    def initialize(definition)
      raise_if_invalid(definition)
      @definition = definition.reject{|attr_name, klass| klass.is_a?(UnionClass)}.merge(
                    definition.select{|attr_name, klass| klass.is_a?(UnionClass)}.
                                map{|attr_name, klass| [attr_name, klass.klasses]}.to_h)
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
        if klass.is_a?(Array)
          if klass.any?{|kls| !kls.is_a?(Class)}
            raise InvalidDefinitionError.new("#{klass} is not an array of Class")
          end
        else
          if !klass.is_a?(Class) && !klass.is_a?(UnionClass)
            raise InvalidDefinitionError.new("#{klass} is not a class")
          end
        end
      end

      nil
    end
  end
end
