require "kt_data_class/version"
require "kt_data_class/factory"
require "kt_data_class/union_syntax"

module KtDataClass
  # @param [Hash] definition
  def create(definition, &block)
    Factory.new(definition).create(&block)
  end

  module_function :create
end
