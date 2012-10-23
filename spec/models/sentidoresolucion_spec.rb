require File.dirname(__FILE__) + '/../spec_helper'

describe Sentidoresolucion do

  before(:each) do
    @sentidoresolucion = FactoryGirl.build(:sentidoresolucion)
  end

  it "debe ser valido" do
    @sentidoresolucion.should be_valid
  end

  describe "to_label" do
    it "es un alias al campo nombre" do
      @sentidoresolucion.nombre.should == @sentidoresolucion.to_label
    end
  end

end
# == Schema Information
#
# Table name: sentidosresolucion
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

