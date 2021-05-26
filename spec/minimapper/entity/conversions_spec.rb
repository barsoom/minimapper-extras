require "minimapper/entity/conversions"

class User
  include Minimapper::Entity

  attribute :signed_up_on, :date
  attribute :flagged, :boolean
  attribute :amount, :big_decimal
end

describe "Conversions" do
  it "can convert dates" do
    expect(User.new(signed_up_on: "2001-01-01").signed_up_on).to eq Date.new(2001, 1, 1)
    expect(User.new(signed_up_on: "BAD DATA").signed_up_on).to be_nil
  end

  it "can convert booleans" do
    expect(User.new(flagged: true).flagged).to eq(true)
    expect(User.new(flagged: "yep").flagged).to eq(true)
    expect(User.new(flagged: nil).flagged).to be_nil
    expect(User.new(flagged: false).flagged).to eq(false)
    expect(User.new(flagged: "1").flagged).to eq(true)
    expect(User.new(flagged: "0").flagged).to eq(false)
  end

  it "can convert big decimals" do
    expect(User.new(amount: "500").amount).to eq BigDecimal(500)
    expect(User.new(amount: "500.23").amount).to eq BigDecimal("500.23")
  end
end
