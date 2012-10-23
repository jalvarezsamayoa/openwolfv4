class Tiporesolucion < ActiveRecord::Base
  attr_accessible :nombre, :actualiza_fecha, :estado_id, \
  :actualiza_fecha_notificacion, :positiva, :aliaspdh

  TIPO_PRORROGA = 4

  validates_presence_of :nombre
  validates_uniqueness_of :nombre

  has_many :resoluciones
  has_many :razonestiposresoluciones
  belongs_to :estado

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      where("tiposresoluciones.nombre like ?", "%#{nombre}%" )
   end
  }

  scope :prorroga, where("id = ?",TIPO_PRORROGA)

  def to_label
    nombre
  end
end

# == Schema Information
#
# Table name: tiposresoluciones
#
#  id                           :integer          not null, primary key
#  nombre                       :string(255)      not null
#  actualiza_fecha              :boolean          default(FALSE)
#  estado_id                    :integer          default(1), not null
#  created_at                   :datetime
#  updated_at                   :datetime
#  actualiza_fecha_notificacion :boolean          default(FALSE)
#  positiva                     :boolean          default(FALSE)
#  aliaspdh                     :string(255)
#

