require File.dirname(__FILE__) + '/../spec_helper'

describe Departamento do

  before(:each) do
    @depto = FactoryGirl.build(:departamento)
  end

  it "es valido" do
    @depto.should be_valid
  end

  it "es invalido" do
    @depto.nombre = nil
    @depto.abreviatura = nil
    @depto.should_not be_valid
  end


end
# == Schema Information
#
# Table name: departamentos
#
#  id          :integer         not null, primary key
#  nombre      :string(255)     not null
#  abreviatura :string(255)     not null
#  created_at  :datetime
#  updated_at  :datetime
#

