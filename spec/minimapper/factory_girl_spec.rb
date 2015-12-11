FactoryGirl = Class.new do
  def self.register_strategy(name, klass)
  end
end

Repository = Class.new

require "minimapper/factory_girl"
require "minimapper/entity"
require "minimapper/entity/belongs_to"

class Payment
  include Minimapper::Entity

  attribute :amount
end

class Order
  include Minimapper::Entity

  attribute :name
  belongs_to :payment
end

class Location
  include Minimapper::Entity

  attribute :name
end

describe CreateThroughRepositoryStrategy do
  let(:entity) { Location.new }
  let(:location_mapper) { double }
  let(:evaluation) { double(object: entity) }

  before do
    allow(Repository).to receive(:locations).and_return(location_mapper)
  end

  it "can create a single entity though a factory class" do
    allow(location_mapper).to receive(:create).with(entity).and_return(true)
    CreateThroughRepositoryStrategy.new.result(evaluation)
  end

  it "raises if the entity isn't valid after create" do
    entity.errors.add :base, "some error"
    allow(location_mapper).to receive(:create).and_return( false)
    expect {
      CreateThroughRepositoryStrategy.new.result(evaluation)
    }.to raise_error("Can't create invalid record: some error")
  end
end

describe CreateThroughRepositoryStrategy, "when there are belongs_to associations" do
  let(:payment_mapper) { double }
  let(:order_mapper) { double }

  before do
    allow(Repository).to receive(:orders).and_return(order_mapper)
    allow(Repository).to receive(:payments).and_return(payment_mapper)
  end

  it "creates dependencies first" do
    payment = Payment.new
    order = Order.new(payment: payment)
    expect(payment_mapper).to receive(:create).ordered.with(payment).and_return(true)
    expect(order_mapper).to receive(:create).ordered.with(order).and_return(true)
    evaluation = double(object: order)
    CreateThroughRepositoryStrategy.new.result(evaluation)
  end

  it "does not create dependencies when not defined" do
    order = Order.new(payment: nil)
    expect(order_mapper).to receive(:create).ordered.with(order).and_return(true)
    evaluation = double(object: order)
    CreateThroughRepositoryStrategy.new.result(evaluation)
  end

  it "does not create an entity when it's already persisted" do
    payment = Payment.new(id: 1)
    order = Order.new(payment: payment)
    expect(payment_mapper).not_to receive(:create)
    expect(order_mapper).to receive(:create).ordered.with(order).and_return(true)
    evaluation = double(object: order)
    CreateThroughRepositoryStrategy.new.result(evaluation)
  end
end
