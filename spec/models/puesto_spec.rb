require File.dirname(__FILE__) + '/../spec_helper'

describe Puesto do

  before(:each) do
    @puesto = FactoryGirl.build(:puesto)
  end

  it "debe ser valido" do
    @puesto.should be_valid
  end

  describe "nombre_completo" do
   it "debe convinar nombrel del pueso e institucion" do
    @puesto.nombre = "Nombre"
    @puesto.institucion.nombre = "Institucion"
    @puesto.nombre_completo.should == "Nombre en Institucion"
   end
  end
end
# == Schema Information
#
# Table name: puestos
#
#  id             :integer         not null, primary key
#  nombre         :string(255)     not null
#  institucion_id :integer         not null
#  created_at     :datetime
#  updated_at     :datetime
#

