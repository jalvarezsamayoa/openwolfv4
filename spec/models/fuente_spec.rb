require File.dirname(__FILE__) + '/../spec_helper'

describe Fuente do

  before(:each) do
    @fuente = FactoryGirl.build(:fuente)
  end

  it "debe ser valido" do
    @fuente.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @fuente.nombre.should == @fuente.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @fuente.nombre = "ABC123"
      @fuente.save
      Fuente.nombre_like('123').should have(1).registro
    end
  end

end
# == Schema Information
#
# Table name: fuentes
#
#  id         :integer         not null, primary key
#  nombre     :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#
