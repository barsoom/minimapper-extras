require "attr_extras"

class CreateThroughRepositoryStrategy
  def result(evaluation)
    Create.new(evaluation.object).create
  end

  private

  class Create
    pattr_initialize :entity

    def create
      entity_class = entity.class
      mapper_name = entity_class.name.underscore.pluralize

      # Recursively creates all dependencies of this entity before
      # going on to the the entity itself. This is here so that we can do
      # "customer { FactoryBot.build(:customer) }" in factories.
      create_dependencies

      if entity.persisted?
        entity
      elsif mapper_with_name(mapper_name).create(entity)
        entity
      else
        errors = entity.errors.full_messages.join(", ")
        raise "Can't create invalid record: #{errors}"
      end
    end

    # Override this if you want to access the mappers some other way.
    def mapper_with_name(name)
      Repository.public_send(name)
    end

    def create_dependencies
      associated_entity_names.each do |name|
        associated_entity = entity.public_send(name)

        if associated_entity
          dependency_entity = self.class.new(associated_entity).create
          entity.public_send("#{name}=", dependency_entity)
        end
      end
    end

    def associated_entity_names
      entity.class.column_names.find_all { |name| name[-3..-1] == '_id' }.map do |belongs_to_id|
        belongs_to_id[0...-3]
      end
    end
  end
end

FactoryBot.register_strategy(:create, CreateThroughRepositoryStrategy)
