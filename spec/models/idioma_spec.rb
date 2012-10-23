require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Idioma do
  before(:each) do
    @idioma = FactoryGirl.build(:idioma)
  end

  it "debe ser valido" do
    @idioma.should be_valid
  end

    describe "to_label" do
    it "es un alias al campo nombre" do
      @idioma.nombre.should == @idioma.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @idioma.nombre = "ABC123"
      @idioma.save
      Idioma.nombre_like('123').should have(1).registro
    end
  end

end

# == Schema Information
#
# Table name: idiomas
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

