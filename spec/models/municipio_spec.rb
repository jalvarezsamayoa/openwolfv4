require File.dirname(__FILE__) + '/../spec_helper'

describe Municipio do

  before(:each) do
    @municipio = FactoryGirl.create(:municipio)
  end

  # it { should validate_presence_of(:nombre) }
  # it { should validate_uniqueness_of(:nombre) }

  it "es valido" do
    @municipio.should be_valid
  end

  it "es invalido" do
    @municipio.nombre = nil
    @municipio.departamento = nil
    @municipio.should_not be_valid
  end

  # describe 'asociaciones' do
  #   it { should belong_to(:departamento) }
  # end

  describe '#nombre_completo' do
    it "debe retornar nombre y departamento" do
      @municipio.nombre = "Muni"
      @municipio.departamento.nombre = "Depto"
      @municipio.nombre_completo.should == "Muni, Depto"
    end
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @municipio.nombre.should == @municipio.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @municipio.nombre = "ABC123"
      @municipio.save
      Municipio.nombre_like('123').should have(1).registro
    end
  end

end
# == Schema Information
#
# Table name: municipios
#
#  id              :integer         not null, primary key
#  nombre          :string(255)     not null
#  departamento_id :integer         not null
#  created_at      :datetime
#  updated_at      :datetime
#
