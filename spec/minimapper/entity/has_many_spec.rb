require "spec_helper"
require "minimapper/entity/has_many"

class Address
  include Minimapper::Entity

  attribute :street
end

class Customer
  include Minimapper::Entity

  has_many :cars

  attribute :addresses_attributes
  has_many :addresses, serialize: true
end

describe Minimapper::Entity::HasMany do
  context "with serialize: false (the default)" do
    it "defaults to an empty array" do
      Customer.new.cars.should be_empty
    end

    it "can be added to" do
      customer = Customer.new
      customer.cars << :foo
      customer.cars.should == [ :foo ]
    end

    it "can be set" do
      customer = Customer.new
      customer.cars = [ :foo ]
      customer.cars.should == [ :foo ]
    end
  end

  context "with serialize: true" do
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

    it "can be set" do
      customer = Customer.new
      customer.addresses = [ :foo ]
      customer.addresses.should == [ :foo ]
    end
  end
end
