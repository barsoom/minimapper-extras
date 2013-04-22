require "spec_helper"
require "minimapper/entity/serialized_association"

class Address
  include Minimapper::Entity

  attribute :street
end

class Customer
  include Minimapper::Entity

  attribute :address_attributes
  attribute :visit_address_attributes

  serialized_association :address
  serialized_association :visit_address, Address
end

describe Minimapper::Entity::SerializedAssociation do
  it "returns an empty associated entity for a new instance" do
    address = Customer.new.address
    address.should be_kind_of(Address)
    address.attributes.should == {}
  end

  it "fills the associated entity using data in entity_attributes" do
    address = Customer.new(address_attributes: { street: "Street 55" }).address
    address.street.should == "Street 55"
  end

  it "memoizes the associated entity" do
    customer = Customer.new(address_attributes: { street: "Street 55" })
    customer.address.should == customer.address
  end

  it "can use a specified entity type" do
    customer = Customer.new(visit_address_attributes: { street: "Street 66" })
    customer.visit_address.street.should == "Street 66"
  end
end
