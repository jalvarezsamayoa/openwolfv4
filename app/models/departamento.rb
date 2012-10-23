class Departamento < ActiveRecord::Base
  attr_accessible :nombre, :abreviatura

  validates_presence_of :nombre
  validates_presence_of :abreviatura
  validates_uniqueness_of :nombre, :abreviatura
  has_many :municipios, :dependent => :destroy

  default_scope :order => :nombre

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      valor = "%#{nombre}%".upcase
      where("departamentos.nombre ilike ?", valor )
   end
  }

  def to_label
    nombre
  end
end

# == Schema Information
#
# Table name: departamentos
#
#  id          :integer          not null, primary key
#  nombre      :string(255)      not null
#  abreviatura :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#

