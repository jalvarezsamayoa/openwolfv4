require File.dirname(__FILE__) + '/../spec_helper'

describe Departamento do

  before(:each) do
    @departamento = FactoryGirl.build(:departamento)
  end

  it "es valido" do
    @departamento.should be_valid
  end

  it "es invalido" do
    @departamento.nombre = nil
    @departamento.abreviatura = nil
    @departamento.should_not be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @departamento.nombre.should == @departamento.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @departamento.nombre = "ABC123"
      @departamento.save
      Departamento.nombre_like('123').should have(1).registro
    end
  end


end
# == Schema Information
#
# Table name: departamentos
#
#  id          :integer         not null, primary key
#  nombre      :string(255)     not null
#  abreviatura :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

