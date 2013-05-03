require "attr_extras"
require "backports/1.9.1/kernel/public_send"

# Mapping of associated entity changes. Creates when not persisted, updates
# when persisted and removes when it has been removed from the in-memory model.
#
# It assumes there isn't many associated entities and that find will load associated entities.
module Minimapper
  module Mapper
    class HasManyAssociation
      pattr_initialize :mapper, :parent_entity, :association_name, :belongs_to_association_name

      def persist_changes
        remove_deleted
        create_or_update
      end

      private

      def remove_deleted
        previous_entities.each do |entity|
          unless current_entities.include?(entity)
            association.delete(entity)
          end
        end
      end

      def create_or_update
        current_entities.each do |entity|
          if entity.persisted?
            association.update(entity)
          else
            entity.public_send("#{belongs_to_association_name}=", parent_entity)
            association.create(entity)
          end
        end
      end

      def current_entities
        parent_entity.public_send(association_name)
      end

      def previous_entities
        mapper.find(parent_entity.id).public_send(association_name)
      end

      def association
        repository.public_send(association_name)
      end

      def repository
        mapper.repository
      end
    end
  end
end
