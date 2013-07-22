require "spec_helper"
require "minimapper/entity/conversions"

class User
  include Minimapper::Entity

  attribute :signed_up_on, :date
  attribute :flagged, :boolean
  attribute :amount, :big_decimal
end

describe "Convertions" do
  it "can covert dates" do
    User.new(:signed_up_on => "2001-01-01").signed_up_on.should == Date.new(2001, 1, 1)
    User.new(:signed_up_on => "BAD DATA").signed_up_on.should be_nil
  end

  it "can convert booleans" do
    User.new(:flagged => true).flagged.should eq(true)
    User.new(:flagged => "yep").flagged.should eq(true)
    User.new(:flagged => nil).flagged.should be_nil
    User.new(:flagged => false).flagged.should eq(false)
    User.new(:flagged => "1").flagged.should eq(true)
    User.new(:flagged => "0").flagged.should eq(false)
  end

  it "can convert big decimals" do
    User.new(amount: "500").amount.should == BigDecimal.new(500)
    User.new(amount: "500.23").amount.should == BigDecimal.new("500.23")
  end
end
