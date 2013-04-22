require "minimapper/entity"

module Minimapper
  module Entity
    module BelongsTo
      def belongs_to(association)
        define_method("#{association}=") do |value|        # def employee=(employee)
          instance_variable_set("@#{association}", value)  #   @employee = employee
          id = value ? value.id : nil                      #   id = employee ? employee.id : nil
          send("#{association}_id=", id)                   #   self.employee_id = id
        end                                                # end

        attribute :"#{association}_id"                     # attribute :employee_id

        define_method(association) do                               # def employee
          ivar = instance_variable_get("@#{association}")           #   ivar = @employee
          if send("#{association}_id") && !ivar                     #   if employee_id && !ivar
            raise "Was assigned #{association}_id but no record!"   #     raise "..."
          else                                                      #   else
            ivar                                                    #     ivar
          end                                                       #   end
        end                                                         # end
      end
    end
  end
end

module Minimapper::Entity::Attributes
  include Minimapper::Entity::BelongsTo
end
