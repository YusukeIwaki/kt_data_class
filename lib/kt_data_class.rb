require "kt_data_class/version"
require "kt_data_class/factory"

module KtDataClass
  # @param [Hash] definition
  def create(definition)
    Factory.new(definition).create
  end

  module_function :create
end
