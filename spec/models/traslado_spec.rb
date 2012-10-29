# traslado_spec.rb
require 'spec_helper'

describe Openwolf::Archivo::Traslado do

  describe "#crear_documento" do
    it "debe generar un nuevo documento" do
      documento = FactoryGirl.create(:documento)

      t = FactoryGirl.build(:documentotraslado, :documento => documento)
      documento = t.crear_documento
      documento.should_not be nil
      documento.should be_instance_of Documento
    end
  end

end
