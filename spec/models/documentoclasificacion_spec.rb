require File.dirname(__FILE__) + '/../spec_helper'

describe Documentoclasificacion do

  before(:each) do
    @documentoclasificacion = FactoryGirl.build(:documentoclasificacion)
  end

  it "debe ser valido" do
    @documentoclasificacion.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @documentoclasificacion.nombre.should == @documentoclasificacion.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @documentoclasificacion.nombre = "ABC123"
      @documentoclasificacion.save
      Documentoclasificacion.nombre_like('123').should have(1).registro
    end
  end
end
# == Schema Information
#
# Table name: documentoclasificaciones
#
#  id                    :integer         not null, primary key
#  nombre                :string(255)
#  documentocategoria_id :integer
#  codigo                :string(255)
#  plantilla             :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#
