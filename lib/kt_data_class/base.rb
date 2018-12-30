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
        instance_variable_set("@#{attr_name}", value)
      end
    end

    def copy(*args, **kwargs)
      unless args.empty?
        raise ArgumentError.new("parameters for copying must be keyword arguments.")
      end
      new_params = hash.merge(kwargs)
      self.class.new(**new_params)
    end

    def hash
      self.class.definition.keys.inject(Hash.new) do |h, attr_name|
        h[attr_name] = instance_variable_get("@#{attr_name}")
        h
      end
    end
    alias_method :to_h, :hash
    alias_method :to_hash, :hash

    # @see http://maeharin.hatenablog.com/entry/20130107/p1
    def to_ary
      self.class.definition.keys.map do |attr_name|
        instance_variable_get("@#{attr_name}")
      end
    end
    alias_method :to_a, :to_ary

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
