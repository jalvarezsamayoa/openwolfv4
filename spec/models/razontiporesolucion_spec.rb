require File.dirname(__FILE__) + '/../spec_helper'

describe Razontiporesolucion do

  before(:each) do
    @razontiporesolucion = FactoryGirl.build(:razontiporesolucion)
  end

  it "debe ser valido" do
    @razontiporesolucion.should be_valid
  end


  describe "to_label" do
    it "es un alias al campo nombre" do
      @razontiporesolucion.nombre.should == @razontiporesolucion.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @razontiporesolucion.nombre = "ABC123"
      @razontiporesolucion.save
      Razontiporesolucion.nombre_like('123').should have(1).registro
    end
  end


end
# == Schema Information
#
# Table name: razonestiposresoluciones
#
#  id                  :integer         not null, primary key
#  nombre              :string(255)     not null
#  tiporesolucion_id   :integer         not null
#  created_at          :datetime
#  updated_at          :datetime
#  informacion_publica :boolean         default(TRUE), not null
#

