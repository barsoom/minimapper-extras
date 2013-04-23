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
  let(:location_mapper) { mock }
  let(:evaluation) { mock(:object => entity) }

  before do
    Repository.stub(:locations).and_return(location_mapper)
  end

  it "can create a single entity though a factory class" do
    location_mapper.should_receive(:create).with(entity).and_return(true)
    CreateThroughRepositoryStrategy.new.result(evaluation)
  end

  it "raises if the entity isn't valid after create" do
    entity.errors.add :base, "some error"
    location_mapper.stub(:create => false)
    lambda {
      CreateThroughRepositoryStrategy.new.result(evaluation)
    }.should raise_error("Can't create invalid record: some error")
  end
end

describe CreateThroughRepositoryStrategy, "when there are belongs_to associations" do
  let(:payment_mapper) { mock }
  let(:order_mapper) { mock }

  before do
    Repository.stub(:orders => order_mapper)
    Repository.stub(:payments => payment_mapper)
  end

  it "creates dependencies first" do
    payment = Payment.new
    order = Order.new(:payment => payment)
    payment_mapper.should_receive(:create).ordered.with(payment).and_return(true)
    order_mapper.should_receive(:create).ordered.with(order).and_return(true)
    evaluation = mock(:object => order)
    CreateThroughRepositoryStrategy.new.result(evaluation)
  end
end
