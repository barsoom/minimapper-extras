require "minimapper/mapper/has_many_association"
require "minimapper/entity"
require "minimapper/entity/belongs_to"
require "minimapper/entity/has_many"

class Contact
  include Minimapper::Entity

  attribute :name

  belongs_to :customer
end

class Customer
  include Minimapper::Entity

  has_many :contacts
end

RSpec.describe Minimapper::Mapper::HasManyAssociation do
  let(:contact) { Contact.new(name: "Joe", id: 1) }
  let(:customer) { Customer.new(id: 1, contacts: [ contact ]) }
  let(:repository) { double(:repository, contacts: contacts_mapper) }
  let(:customer_mapper) { double(:customer_mapper, find: customer, repository: repository) }
  let(:contacts_mapper) { double(:contacts_mapper) }

  it "updates changed associated entities" do
    expect(contacts_mapper).to receive(:update).with(contact)
    has_many_association = described_class.new(customer_mapper, customer, "contacts", "customer")
    has_many_association.persist_changes
  end

  it "creates new associated entities and assigns the belongs_to association" do
    contact.id = nil

    expect(contacts_mapper).to receive(:create).with(contact)
    has_many_association = described_class.new(customer_mapper, customer, "contacts", "customer")
    has_many_association.persist_changes
    expect(contact.customer).to eq customer
  end

  it "removes associated entities that no longer exist" do
    allow(customer_mapper).to receive(:find).and_return(Customer.new(id: 1, contacts: [ contact ]))
    customer.contacts = []
    expect(contacts_mapper).to receive(:delete).with(contact)
    has_many_association = described_class.new(customer_mapper, customer, "contacts", "customer")
    has_many_association.persist_changes
  end
end
