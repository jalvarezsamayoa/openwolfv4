require File.dirname(__FILE__) + '/../spec_helper'

describe Tipomensaje do

  before(:each) do
    @tipomensaje = FactoryGirl.build(:tipomensaje)
  end

  it "debe ser valido" do
    @tipomensaje.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @tipomensaje.nombre.should == @tipomensaje.to_label
    end
  end

end
# == Schema Information
#
# Table name: tipomensajes
#
#  id         :integer         not null, primary key
#  nombre     :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

