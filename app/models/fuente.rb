class Fuente < ActiveRecord::Base
  attr_accessible :nombre

  validates_presence_of :nombre
  validates_uniqueness_of :nombre

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      where("fuentes.nombre ilike ?", "%#{nombre}%" )
    end
  }

  def to_label
    nombre
  end
end

# == Schema Information
#
# Table name: fuentes
#
#  id         :integer          not null, primary key
#  nombre     :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#