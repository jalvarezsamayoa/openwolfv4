require File.dirname(__FILE__) + '/../spec_helper'

describe Tiporesolucion do

  before(:each) do
    @tiporesolucion = FactoryGirl.build(:tiporesolucion)
  end

  it "debe ser valido" do
    @tiporesolucion.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @tiporesolucion.nombre.should == @tiporesolucion.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @tiporesolucion.nombre = "ABC123"
      @tiporesolucion.save
      Tiporesolucion.nombre_like('123').should have(1).registro
    end
  end

end
# == Schema Information
#
# Table name: tiposresoluciones
#
#  id                           :integer         not null, primary key
#  nombre                       :string(255)     not null
#  actualiza_fecha              :boolean         default(FALSE)
#  estado_id                    :integer         default(1), not null
#  created_at                   :datetime
#  updated_at                   :datetime
#  actualiza_fecha_notificacion :boolean         default(FALSE)
#  positiva                     :boolean         default(FALSE)
#  aliaspdh                     :string(255)
#

