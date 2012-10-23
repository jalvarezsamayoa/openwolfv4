require File.dirname(__FILE__) + '/../spec_helper'

describe Motivoprorroga do

  before(:each) do
    @motivoprorroga = FactoryGirl.build(:motivoprorroga)
  end

  it "debe ser valido" do
    @motivoprorroga.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @motivoprorroga.nombre.should == @motivoprorroga.to_label
    end
  end
end
# == Schema Information
#
# Table name: motivosprorroga
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

