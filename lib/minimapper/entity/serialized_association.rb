require "minimapper/entity"

module Minimapper
  module Entity
    module SerializedAssociation
      def serialized_association(name, entity_class = nil)
        if entity_class
          class_name = entity_class.name
        else
          class_name = name.to_s.camelcase
        end

        define_method(name) do                                                # def foo
          eval("@#{name} ||= ::#{class_name}.new(#{name}_attributes || {})")  #   @foo ||= ::Foo.new(foo_attributes || {})
        end                                                                   # end
      end
    end

    module Attributes
      include SerializedAssociation
    end
  end
end
