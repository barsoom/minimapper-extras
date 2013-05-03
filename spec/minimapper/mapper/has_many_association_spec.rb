require "spec_helper"
require "minimapper/mapper/has_many_association"
require "minimapper/entity"
require "minimapper/entity/belongs_to"

class Contact
  include Minimapper::Entity

  attribute :name

  belongs_to :customer
end

class Customer
  include Minimapper::Entity

  # TODO: add macro
  attr_accessor :contacts
  def contacts
    @contacts || []
  end
end

describe Minimapper::Mapper::HasManyAssociation do
  let(:contact) { Contact.new(:name => "Joe", :id => 1) }
  let(:customer) { Customer.new(:id => 1, :contacts => [ contact ]) }
  let(:repository) { mock(:contacts => contacts_mapper) }
  let(:customer_mapper) { mock(:find => customer, :repository => repository) }
  let(:contacts_mapper) { mock }

  it "updates changed associated entities" do
    contacts_mapper.should_receive(:update).with(contact)
    has_many_association = described_class.new(customer_mapper, customer, "contacts", "customer")
    has_many_association.persist_changes
  end

  it "creates new associated entities and assigns the belongs_to association" do
    contact.id = nil

    contacts_mapper.should_receive(:create).with(contact)
    has_many_association = described_class.new(customer_mapper, customer, "contacts", "customer")
    has_many_association.persist_changes
    contact.customer.should == customer
  end

  it "removes associated entities that no longer exist" do
    customer_mapper.stub(:find => Customer.new(:id => 1, :contacts => [ contact ]))
    customer.contacts = []
    contacts_mapper.should_receive(:delete).with(contact)
    has_many_association = described_class.new(customer_mapper, customer, "contacts", "customer")
    has_many_association.persist_changes
  end
end
