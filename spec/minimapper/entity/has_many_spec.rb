require "spec_helper"
require "minimapper/entity/has_many"

class Customer
  include Minimapper::Entity

  has_many :cars
end

describe Minimapper::Entity::HasMany do
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
