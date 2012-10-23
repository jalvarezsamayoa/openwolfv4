require File.dirname(__FILE__) + '/../spec_helper'

describe Recursorevision do

  before(:each) do
    @recurso = FactoryGirl.build(:recursorevision)
  end

  it "debe ser valido" do
    @recurso.should be_valid
  end

  describe "#nuevo_numero" do
    context "debe generar un codigo" do

      it "tipo string" do
        @recurso.nuevo_numero.should be_instance_of(String)
      end

      context "que incluye" do
        before(:each) do
          @codigo = @recurso.nuevo_numero.split('-')
        end

        it "codigo de la institucion" do
          institucion = @recurso.institucion
          @codigo[0].should == institucion.codigo
        end

        it "codigo de clasificacion documental" do
          @codigo[1].should == Documentoclasificacion::REVISION
        end

        it "ano de generacion" do
          @codigo[2].should == Date.today.year.to_s
        end

        it "correlativo" do
          @codigo[3].should == '000001'
        end

      end
    end
  end

  describe "cleanup" do
    it "debe proveer predeterminados" do
      @recurso.institucion_id = nil
      @recurso.numero = nil

      @recurso.cleanup

      @recurso.institucion_id.should_not be(nil)
      @recurso.numero.should_not be(nil)
    end
  end
end
# == Schema Information
#
# Table name: recursosrevision
#
#  id                        :integer         not null, primary key
#  solicitud_id              :integer
#  fecha_presentacion        :date
#  fecha_notificacion        :date
#  fecha_resolucion          :date
#  descripcion               :text
#  sentidoresolucion_id      :integer
#  institucion_id            :integer
#  usuario_id                :integer
#  created_at                :datetime
#  updated_at                :datetime
#  numero                    :string(255)
#  documentoclasificacion_id :integer         default(3)
#
