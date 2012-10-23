require 'spec_helper'

describe Archivo do
   before(:each) do
    @archivo = FactoryGirl.create(:archivo)
  end

  # it { should validate_presence_of(:nombre) }
  # it { should validate_uniqueness_of(:nombre)  }

  it "es valido" do
    @archivo.should be_valid
  end

  it "es invalido" do
    @archivo.nombre = nil
    @archivo.should_not be_valid
  end

   describe "to_label" do
    it "es un alias al campo nombre" do
      @archivo.nombre.should == @archivo.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @archivo.nombre = "ABC123"
      @archivo.save
      Archivo.nombre_like('123').should have(1).registro
    end
  end

end
# == Schema Information
#
# Table name: archivos
#
#  id             :integer         not null, primary key
#  nombre         :string(255)     not null
#  institucion_id :integer         not null
#  created_at     :datetime
#  updated_at     :datetime
#

