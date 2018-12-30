require "kt_data_class/version"
require "kt_data_class/definition"
require "kt_data_class/factory"

module KtDataClass
  def create(*attr_names, **kwargs, &block)
    definition = Definition.new(attr_names)
    Factory.new(definition).create(&block)
  end

  module_function :create
end
