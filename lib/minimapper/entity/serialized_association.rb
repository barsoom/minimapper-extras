require "minimapper/entity"
require "backports/1.9.1/kernel/public_send"
require "backports/1.8.7/kernel/instance_exec"

module Minimapper
  module Entity
    module SerializedAssociation
      def serialized_association(name, entity_class_or_proc = nil)
        define_method(name) do                                          # def foo
          attributes = public_send("#{name}_attributes") || {}          #  attributes = foo_attributes
          entity = instance_variable_get("@#{name}")                    #  entity = @foo

          if entity_class_or_proc.is_a?(Proc)
            entity ||= instance_exec(attributes, &entity_class_or_proc) # call proc in instance context
          else
            entity_class = entity_class_or_proc ||
              name.to_s.camelcase.constantize

            entity ||= entity_class.new(attributes)                     # entity ||= Foo.new(attributes)
          end

          instance_variable_set("@#{name}", entity)                     # @foo = entity
        end
      end
    end

    module Attributes::ClassMethods
      include SerializedAssociation
    end
  end
end
