require File.dirname(__FILE__) + '/../spec_helper'

describe Rangoedad do

  before(:each) do
    @rangoedad = FactoryGirl.build(:rangoedad)
  end

  it "debe ser valido" do
    @rangoedad.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @rangoedad.nombre.should == @rangoedad.to_label
    end
  end

end
# == Schema Information
#
# Table name: rangosedad
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

