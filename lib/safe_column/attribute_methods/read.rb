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

        code = "attr_name = '#{attr_name}'; #{access_code}"
        if ancestors.include? SafeColumn
          code += ";v && v.is_a?(String) && self.safe_columns.include?(attr_name.to_sym) ? ActiveSupport::SafeBuffer.new(v): v"
        end
        code
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
  end
end
