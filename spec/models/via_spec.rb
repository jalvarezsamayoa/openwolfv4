require File.dirname(__FILE__) + '/../spec_helper'

describe Via do
  before(:each) do
    @via = FactoryGirl.create(:via)
  end

  # it { should validate_presence_of(:nombre) }
  # it { should validate_uniqueness_of(:nombre)  }

  it "es valido" do
    @via.should be_valid
  end

  it "es invalido" do
    @via.nombre = nil
    @via.should_not be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @via.nombre.should == @via.to_label
    end
  end

  describe "nombre_like" do
    it "busca registros donde el nombre coincide con el parametro" do
      @via.nombre = "ABC123"
      @via.save
      Via.nombre_like('123').should have(1).registro
    end
  end


end
# == Schema Information
#
# Table name: vias
#
#  id         :integer         not null, primary key
#  nombre     :string(255)     not null
#  created_at :datetime
#  updated_at :datetime
#

