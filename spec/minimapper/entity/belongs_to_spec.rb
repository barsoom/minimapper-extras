require "spec_helper"
require "minimapper/entity/belongs_to"

class Balloon
  include Minimapper::Entity
end

class Customer
  include Minimapper::Entity

  belongs_to :balloon
end

describe Minimapper::Entity::BelongsTo do
  it "defines an _id attribute" do
    customer = Customer.new
    customer.balloon_id = 123
    customer.attributes.should include(:balloon_id)
  end

  it "assigns id when assigning entity" do
    customer = Customer.new
    balloon = Balloon.new(:id => 123)
    customer.balloon = balloon
    customer.balloon_id.should == 123
  end

  it "provides an entity writer" do
    customer = Customer.new
    balloon = Balloon.new
    customer.balloon = balloon
    customer.balloon.should == balloon
  end

  # The mapper should load the record.
  # If it doesn't, we complain to help avoid confusion.
  it "complains if id exists but record isn't loaded" do
    # Only id, no loaded entity.
    customer = Customer.new
    customer.balloon_id = 123
    expect { customer.balloon }.to raise_error(/balloon_id but no record/)

    # Loaded entity, also sets id.
    customer = Customer.new
    balloon = Balloon.new(:id => 123)
    customer.balloon = balloon
    customer.balloon_id.should == 123  # Sanity.
    customer.balloon.should == balloon

    # Loaded entity without id.
    # NOTE: a mapper won't see the balloon.
    customer = Customer.new
    balloon = Balloon.new(:id => nil)
    customer.balloon = balloon
    customer.balloon_id.should be_nil
    customer.balloon.should == balloon

    # No id, no entity.
    customer = Customer.new
    customer.balloon = nil
    customer.balloon_id = nil
    customer.balloon.should be_nil
  end
end
