require "kt_data_class/base"

module KtDataClass
  class Factory
    # @param [Definition] definition
    def initialize(definition)
      @definition = definition
    end

    def create(&block)
      member_definition = @definition
      Class.new(Base) do
        define_singleton_method(:definition) do
          member_definition
        end
        attr_reader(*member_definition.keys)

        unless block.nil?
          class_eval(&block)
        end
      end
    end
  end
end
