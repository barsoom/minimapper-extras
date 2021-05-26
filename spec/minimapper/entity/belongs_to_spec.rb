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
    expect(customer.attributes).to include(:balloon_id)
  end

  it "assigns id when assigning entity" do
    customer = Customer.new
    balloon = Balloon.new(id: 123)
    customer.balloon = balloon
    expect(customer.balloon_id).to eq 123
  end

  it "provides an entity writer" do
    customer = Customer.new
    balloon = Balloon.new
    customer.balloon = balloon
    expect(customer.balloon).to eq balloon
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
    balloon = Balloon.new(id: 123)
    customer.balloon = balloon
    expect(customer.balloon_id).to eq 123  # Sanity.
    expect(customer.balloon).to eq balloon

    # Loaded entity without id.
    # NOTE: a mapper won't see the balloon.
    customer = Customer.new
    balloon = Balloon.new(id: nil)
    customer.balloon = balloon
    expect(customer.balloon_id).to be_nil
    expect(customer.balloon).to eq balloon

    # No id, no entity.
    customer = Customer.new
    customer.balloon = nil
    customer.balloon_id = nil
    expect(customer.balloon).to be_nil
  end
end
