require "spec_helper"
require "minimapper/entity/has_many"

class Address
  include Minimapper::Entity

  attribute :street
end

class Customer
  include Minimapper::Entity

  has_many :cars

  has_many :addresses, serialize: true
end

describe Minimapper::Entity::HasMany do
  context "with serialize: false (the default)" do
    it "defaults to an empty array" do
      expect(Customer.new.cars).to be_empty
    end

    it "can be added to" do
      customer = Customer.new
      customer.cars << :foo
      expect(customer.cars).to eq [ :foo ]
    end

    it "can be set" do
      customer = Customer.new
      customer.cars = [ :foo ]
      expect(customer.cars).to eq [ :foo ]
    end
  end

  context "with serialize: true" do
    it "returns an empty collection for a new instance" do
      expect(Customer.new.addresses).to be_empty
    end

    it "fills the collection using data in entities_attributes" do
      addresses = Customer.new(addresses_attributes: [ { street: "Street 55" } ]).addresses
      expect(addresses.size).to eq 1
      expect(addresses.first.street).to eq "Street 55"
    end

    it "memoizes the collection" do
      customer = Customer.new(addresses_attributes: [ { street: "Street 55" } ])
      expect(customer.addresses).to eq customer.addresses
    end

    it "can be set" do
      customer = Customer.new
      customer.addresses = [ :foo ]
      expect(customer.addresses).to eq [ :foo ]
    end
  end
end
