class Resolucion < ActiveRecord::Base
  include Openwolf::Laip::Resolucion

  validates_presence_of :numero, :descripcion
  validates_uniqueness_of :numero

  belongs_to :solicitud
  belongs_to :usuario
  belongs_to :institucion
  belongs_to :tiporesolucion
  belongs_to :razontiporesolucion

  before_validation :cleanup
  after_save :actualizar_solicitud
  after_create :notificar_creacion
  after_destroy :revertir_resolucion

  attr_accessor :dont_send_email

  scope :negativas, :conditions => ["resoluciones.tiporesolucion_id = 3"]
  scope :prorrogas, :conditions => ["resoluciones.tiporesolucion_id = 4"]
  scope :tipo_positiva, where("tiposresoluciones.positiva = ?",true).includes(:tiporesolucion)
  scope :tipo_negativa, where("tiposresoluciones.positiva = ?",false).includes(:tiporesolucion)
  scope :finales, where("estados.final = ?",true).includes(:tiporesolucion => :estado)



end

# == Schema Information
#
# Table name: resoluciones
#
#  id                        :integer          not null, primary key
#  numero                    :string(255)      not null
#  solicitud_id              :integer          not null
#  usuario_id                :integer          not null
#  institucion_id            :integer          not null
#  descripcion               :text             not null
#  tiporesolucion_id         :integer          not null
#  razontiporesolucion_id    :integer          not null
#  nueva_fecha               :date
#  created_at                :datetime
#  updated_at                :datetime
#  informacion_publica       :boolean          default(TRUE), not null
#  documentoclasificacion_id :integer          default(2)
#  fecha                     :date
#  fecha_notificacion        :date
#

