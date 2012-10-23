require File.dirname(__FILE__) + '/../spec_helper'

describe Documentocategoria do

  before(:each) do
    @documentocategoria = FactoryGirl.build(:documentocategoria)
  end

  # it { should validate_presence_of(:nombre) }
  # it { @documentocategoria.save; should validate_uniqueness_of(:nombre, :scope => :parent_id) }

  it "debe ser valido" do
    @documentocategoria.should be_valid
  end

   describe "to_label" do
    it "es un alias al campo nombre" do
      @documentocategoria.nombre.should == @documentocategoria.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @documentocategoria.nombre = "ABC123"
      @documentocategoria.save
      Documentocategoria.nombre_like('123').should have(1).registro
    end
  end


end
# == Schema Information
#
# Table name: documentocategorias
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  parent_id  :integer
#  lft        :integer
#  rgt        :integer
#  created_at :datetime
#  updated_at :datetime
#

