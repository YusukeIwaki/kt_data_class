module KtDataClass
  class Base
    def initialize(*args, **kwargs)
      unless args.empty?
        raise ArgumentError.new("data class must be initialized with keyword arguments.")
      end

      (self.class.definition.keys - kwargs.keys).each do |missing_key|
        raise ArgumentError.new("missing keyword: #{missing_key}")
      end
      (kwargs.keys - self.class.definition.keys).each do |unknown_key|
        raise ArgumentError.new("unknown keyword: #{unknown_key}")
      end

      kwargs.each do |attr_name, value|
        klass = self.class.definition[attr_name]
        unless value.is_a?(klass)
          raise ArgumentError.new("type mismatch: #{attr_name} must be a #{klass}, #{value.class} given")
        end
        instance_variable_set("@#{attr_name}", value)
      end
    end
  end
end
