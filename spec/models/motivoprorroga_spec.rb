require File.dirname(__FILE__) + '/../spec_helper'

describe Motivoprorroga do

  before(:each) do
    @motivoprorroga = FactoryGirl.build(:motivoprorroga)
  end

  it "debe ser valido" do
    @motivoprorroga.should be_valid
  end

  describe '#metodo' do
    it 'debe hacer algo' do
      pending
    end
  end

end
# == Schema Information
#
# Table name: motivosprorroga
#
#  id         :integer         not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

