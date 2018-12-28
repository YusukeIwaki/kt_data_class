module KtDataClass
  class UnionClass
    # @param [Array<Class>]
    def initialize(klasses)
      if !klasses.is_a?(Array) || klasses.any?{|klass| !klass.is_a?(Class)}
        raise ArgumentError.new("klasses must be an array of Class")
      end
      @klasses = klasses
    end

    attr_reader :klasses

    def |(other)
      if other.is_a?(UnionClass)
        UnionClass.new(@klasses + other.klasses)
      elsif other.is_a?(Class)
        UnionClass.new(@klasses + [other])
      else
        raise ArgumentError.new("#{other.class} can't be unioned")
      end
    end
  end

  module UnionSyntax
    refine Class do
      def |(other_klass)
        unless other_klass.is_a?(Class)
          raise ArgumentError.new("#{other_klass.class} can't be unioned")
        end
        UnionClass.new([self, other_klass])
      end
    end
  end
end