require "spec_helper"
require "minimapper/entity/serialized_collection"

class Address
  include Minimapper::Entity

  attribute :street
end

class Customer
  include Minimapper::Entity

  attribute :addresses_attributes
  serialized_collection :addresses
end

describe Minimapper::Entity::SerializedCollection do
  it "returns an empty collection for a new instance" do
    Customer.new.addresses.should be_empty
  end

  it "fills the collection using data in entities_attributes" do
    addresses = Customer.new(:addresses_attributes => [ { :street => "Street 55" } ]).addresses
    addresses.size.should == 1
    addresses.first.street.should == "Street 55"
  end

  it "memoizes the collection" do
    customer = Customer.new(:addresses_attributes => [ { :street => "Street 55" } ])
    customer.addresses.should == customer.addresses
  end
end
