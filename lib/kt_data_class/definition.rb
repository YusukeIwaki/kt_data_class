module KtDataClass
  class InvalidDefinitionError < ArgumentError ; end

  class Definition
    # @param [Array<Symbol>] attr_names
    def initialize(attr_names)
      raise_if_invalid(attr_names)
      @attr_names = attr_names
    end

    def keys
      @attr_names
    end

    private

    def raise_if_invalid(attr_names)
      if !attr_names.is_a?(Array) || attr_names.any?{ |attr_name| !attr_name.is_a?(Symbol) }
        raise InvalidDefinitionError.new("class definition must be specified with Array of Symbols")
      end
      duplicated_names = attr_names.group_by{|attr_name| attr_name}.values.select{|names| names.count >= 2}
      unless duplicated_names.empty?
        attr_names = duplicated_names.map(&:first)
        raise InvalidDefinitionError.new("each argument is allowed to use only once. [#{attr_names.join(", ")}] has been used more than once.")
      end
    end
  end
end