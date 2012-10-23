require File.dirname(__FILE__) + '/../spec_helper'

describe Profesion do

  before(:each) do
    @profesion = FactoryGirl.build(:profesion)
  end

  it "debe ser valido" do
    @profesion.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @profesion.nombre.should == @profesion.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @profesion.nombre = "ABC123"
      @profesion.save
      Profesion.nombre_like('123').should have(1).registro
    end
  end
end
# == Schema Information
#
# Table name: profesiones
#
#  id         :integer         not null, primary key
#  nombre     :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

