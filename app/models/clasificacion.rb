class Clasificacion < ActiveRecord::Base
  attr_accessible :nombre

  validates_presence_of :nombre
  validates_uniqueness_of :nombre

  has_many :solicitudes

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      where("clasificaciones.nombre like ?", "%#{nombre}%" )
    end
  }

  def to_label
    nombre
  end
end

# == Schema Information
#
# Table name: clasificaciones
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#4

