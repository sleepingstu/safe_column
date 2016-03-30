require 'active_record'

require "safe_column/version"
require "safe_column/attribute_methods/read"

module SafeColumn
  def self.included(base)
    base.extend AttributeMethods::Read::ClassMethods
  end

  attr_writer :safe_columns

  def safe_columns
    @safe_columns || []
  end

  protected
  def is_safe_string_column?(v, attr_name)
    v && v.is_a?(String) && self.safe_columns.include?(attr_name.to_sym)
  end
end