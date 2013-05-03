require "minimapper/entity"

module Minimapper
  module Entity
    module HasMany
      def has_many(name)
        attr_writer name

        define_method(name) do
          # @foo ||= []
          ivar = instance_variable_get("@#{name}")

          if ivar
            ivar
          else
            instance_variable_set("@#{name}", [])
          end
        end
      end
    end
  end
end

module Minimapper::Entity::Attributes
  include Minimapper::Entity::HasMany
end
