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
      # "customer { FactoryGirl.build(:customer) }" in factories.
      create_dependencies

      if mapper_with_name(mapper_name).create(entity)
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
        dependency_entity = self.class.new(entity.public_send(name)).create
        entity.public_send("#{name}=", dependency_entity)
      end
    end

    def associated_entity_names
      entity.class.column_names.find_all { |name| name[-3..-1] == '_id' }.map do |belongs_to_id|
        belongs_to_id[0...-3]
      end
    end
  end
end

FactoryGirl.register_strategy(:create, CreateThroughRepositoryStrategy)
