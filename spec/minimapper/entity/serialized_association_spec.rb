require "minimapper/entity/serialized_association"

class Address
  include Minimapper::Entity

  attribute :street
end

class CustomerAddress
  include Minimapper::Entity

  def initialize(customer, attributes)
    @customer = customer
    super(attributes)
  end

  def customer_name
    @customer.name
  end

  attribute :street
end

class Customer
  include Minimapper::Entity

  attribute :name

  serialized_association :address
  serialized_association :visit_address, Address
  serialized_association :custom_address, lambda { |attributes| CustomerAddress.new(self, attributes) }
end

describe Minimapper::Entity::SerializedAssociation do
  it "returns an empty associated entity for a new instance" do
    address = Customer.new.address
    expect(address).to be_kind_of(Address)
    expect(address.attributes).to be_empty
  end

  it "fills the associated entity using data in entity_attributes" do
    address = Customer.new(address_attributes: { street: "Street 55" }).address
    expect(address.street).to eq "Street 55"
  end

  it "memoizes the associated entity" do
    customer = Customer.new(address_attributes: { street: "Street 55" })
    expect(customer.address).to eq customer.address
  end

  it "can use a specified entity type" do
    customer = Customer.new(visit_address_attributes: { street: "Street 66" })
    expect(customer.visit_address.street).to eq "Street 66"
  end

  it "can use a lambda to construct addresses" do
    customer = Customer.new(name: "Joe", custom_address_attributes: { street: "Street 66" })
    expect(customer.custom_address.street).to eq "Street 66"
    expect(customer.custom_address.customer_name).to eq "Joe"
  end
end
