require 'active_record'

require "safe_column/version"

module SafeColumn
  def self.included(base)
    base.class_eval do
      # base.send(:include, AttributeMethods::Read)
      # attr_accessor :safe_columns



    end
  end

  attr_writer :safe_columns
   # def safe_columns=(safe_columns)
   #      # binding.pry
   #      @safe_columns = safe_columns
   #    end

      def safe_columns
        # binding.pry
        @safe_columns || []
        # %i(title body)
      end
end

module ActiveRecord
  module AttributeMethods
    module Read
      module ClassMethods
          def internal_attribute_access_code(attr_name, cast_code)
            access_code = "(v=@attributes[attr_name]) && #{cast_code}"

            unless attr_name == primary_key
              access_code.insert(0, "missing_attribute(attr_name, caller) unless @attributes.has_key?(attr_name); ")
            end

            if cache_attribute?(attr_name)
              access_code = "@attributes_cache[attr_name] ||= (#{access_code})"
            end

            code = "attr_name = '#{attr_name}'; #{access_code};"
            if ancestors.include? SafeColumn
              code += "puts attr_name;puts safe_columns.inspect;v && v.is_a?(String) && self.safe_columns.include?(attr_name.to_sym) ? ActiveSupport::SafeBuffer.new(v): v"
            end
          end

          def external_attribute_access_code(attr_name, cast_code)
            access_code = "v && #{cast_code}"

            if cache_attribute?(attr_name)
              access_code = "attributes_cache[attr_name] ||= (#{access_code})"
            end

            access_code
          end

          def attribute_cast_code(attr_name)
            columns_hash[attr_name].type_cast_code('v')
          end
      end

      # Returns the value of the attribute identified by <tt>attr_name</tt> after it has been typecast (for example,
      # "2004-12-12" in a data column is cast to a date object, like Date.new(2004, 12, 12)).
      def read_attribute(attr_name)
        self.class.type_cast_attribute(attr_name, @attributes, @attributes_cache)
      end
    end
  end
end