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
        if klass.is_a?(Array)
          if klass.none?{|kls| value.is_a?(kls)}
            raise ArgumentError.new("type mismatch: #{attr_name} must be one of #{klass}, #{value.class} given")
          end
        else
          unless value.is_a?(klass)
            raise ArgumentError.new("type mismatch: #{attr_name} must be a #{klass}, #{value.class} given")
          end
        end
        instance_variable_set("@#{attr_name}", value)
      end
    end

    def hash
      self.class.definition.keys.inject(Hash.new) do |h, attr_name|
        h[attr_name] = instance_variable_get("@#{attr_name}")
        h
      end
    end
    alias_method :to_h, :hash
    alias_method :to_hash, :hash

    def to_s
      hash.to_s
    end

    def ==(other)
      self.hash == other.hash
    end

    def eql?(other)
      self.class == other.class && self.hash.eql?(other.hash)
    end
  end
end
