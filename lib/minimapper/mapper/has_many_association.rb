require "attr_extras"
require "backports/1.9.1/kernel/public_send"

# Mapping of associated entity changes. Creates when not persisted, updates
# when persisted and removes when it has been removed from the in-memory model.
#
# It assumes there isn't many associated entities and that find will load associated entities.
module Minimapper
  module Mapper
    class HasManyAssociation
      pattr_initialize :mapper, :entity, :association_name, :belongs_to_association_name

      def persist_changes
        remove_deleted
        create_or_update
      end

      private

      def remove_deleted
        previous_entities.each do |previous_entity|
          unless current_entities.include?(previous_entity)
            association.delete(previous_entity)
          end
        end
      end

      def create_or_update
        current_entities.each do |associated_entity|
          if associated_entity.persisted?
            association.update(associated_entity)
          else
            associated_entity.public_send("#{belongs_to_association_name}=", entity)
            association.create(associated_entity)
          end
        end
      end

      def current_entities
        entity.public_send(association_name)
      end

      def previous_entities
        mapper.find(entity.id).public_send(association_name)
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
