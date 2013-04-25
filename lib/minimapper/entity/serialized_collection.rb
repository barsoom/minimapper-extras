require "minimapper/entity"

module Minimapper
  module Entity
    module SerializedCollection
      def serialized_collection(name)
        entity_class = name.to_s.singularize.camelcase.constantize

        define_method(name) do
          ivar = instance_variable_get("@#{name}")

          if ivar
            ivar
          else
            attributes = send("#{name}_attributes")
            data = (attributes || []).map { |attr| entity_class.new(attr) }
            instance_variable_set("@#{name}", data)
          end
        end
      end
    end

    module Attributes
      include SerializedCollection
    end
  end
end
