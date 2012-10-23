require File.dirname(__FILE__) + '/../spec_helper'

describe Clasificacion do

  before(:each) do
    @clasificacion = FactoryGirl.build(:clasificacion)
  end

  it "debe ser valido" do
    @clasificacion.should be_valid
  end

   describe "to_label" do
    it "es un alias al campo nombre" do
      @clasificacion.nombre.should == @clasificacion.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @clasificacion.nombre = "ABC123"
      @clasificacion.save
      Clasificacion.nombre_like('123').should have(1).registro
    end
  end


end
# == Schema Information
#
# Table name: clasificaciones
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

