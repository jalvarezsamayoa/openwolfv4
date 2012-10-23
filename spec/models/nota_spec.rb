# -*- coding: utf-8 -*-
require 'spec_helper'

describe Nota do
  before(:each) do
    @nota = FactoryGirl.create(:nota)
  end


  it "es valido" do
    @nota.should be_valid
  end

  it "es invalido" do
    @nota.texto = nil
    @nota.should_not be_valid
  end

  describe "#tipo_nombre" do
    it "regresa valor segun estado de #informacion_publica" do
      @nota.informacion_publica = false
      @nota.tipo_nombre.should == 'Interno'

      @nota.informacion_publica = true
      @nota.tipo_nombre.should == 'Pública'
    end
  end

end
# == Schema Information
#
# Table name: notas
#
#  id                  :integer         not null, primary key
#  proceso_id          :integer
#  proceso_type        :string(255)
#  usuario_id          :integer
#  texto               :text
#  created_at          :datetime
#  updated_at          :datetime
#  informacion_publica :boolean         default(TRUE), not null
#

