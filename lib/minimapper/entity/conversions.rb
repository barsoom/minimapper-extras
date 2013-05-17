require 'minimapper/entity'
require "date"

class ToDate
  def convert(value)
    Date.parse(value) rescue nil
  end
end

class ToBoolean
  def convert(value)
    value && value != "0"
  end
end

Minimapper::Entity::Convert.register_converter(:date, ToDate.new)
Minimapper::Entity::Convert.register_converter(:boolean, ToBoolean.new)
