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
end