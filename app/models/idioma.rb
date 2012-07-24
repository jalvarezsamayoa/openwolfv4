class Idioma < ActiveRecord::Base
  attr_accessible :nombre

  has_many :solicitudes

  validates :nombre, :presence => true, :uniqueness => true

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      valor = "%"+nombre+"%"
      where("idiomas.nombre ilike ?", valor )
   end
  }

  def to_label
    nombre
  end

end

# == Schema Information
#
# Table name: idiomas
#
#  id         :integer          not null, primary key
#  nombre     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

