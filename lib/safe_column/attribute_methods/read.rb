module AttributeMethods
  module Read
    module ClassMethods
      include ActiveRecord::AttributeMethods::Read::ClassMethods

      alias_method :original_internal_attribute_access_code, :internal_attribute_access_code

      def internal_attribute_access_code(attr_name, cast_code)
        code = original_internal_attribute_access_code(attr_name, cast_code)

        unless cache_attribute? attr_name
          code += ";is_safe_string_column?(v, attr_name) ? ActiveSupport::SafeBuffer.new(v): v"
        else
          code
        end
      end
    end
  end
end
