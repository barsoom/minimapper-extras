require "minimapper/entity"

module Minimapper
  module Entity
    module HasMany
      def has_many(name, opts = {})
        serialize = opts.fetch(:serialize, false)

        attr_writer name

        if serialize
          attribute_name = "#{name}_attributes"
          attribute attribute_name

          setup_has_many(name) do
            attributes = send(attribute_name)
            entity_class = name.to_s.singularize.camelcase.constantize
            (attributes || []).map { |attr| entity_class.new(attr) }
          end
        else
          setup_has_many(name) { [] }
        end
      end

      private

      def setup_has_many(name, &data)
        # Basically does: @thename ||= data.call
        # The data block is evaluated in the instance context.
        define_method(name) do
          instance_variable_get("@#{name}") ||
            instance_variable_set("@#{name}", instance_eval(&data))
        end
      end
    end
  end
end

module Minimapper::Entity::Attributes::ClassMethods
  include Minimapper::Entity::HasMany
end
