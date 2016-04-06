module AttributeMethods
  module Read
    module ClassMethods
      include ActiveRecord::AttributeMethods::Read::ClassMethods

      alias_method :original_internal_attribute_access_code, :internal_attribute_access_code

      def internal_attribute_access_code(attr_name, cast_code)
        code = original_internal_attribute_access_code(attr_name, cast_code)

        unless cache_attribute? attr_name
          lines = code.split(";")
          old_return_value = lines.pop
          lines << "r = (#{old_return_value})"
          lines << "is_safe_string_column?(r, attr_name) ? ActiveSupport::SafeBuffer.new(r): r"
          lines.join(";")
        else
          code
        end
      end
    end
  end
end
