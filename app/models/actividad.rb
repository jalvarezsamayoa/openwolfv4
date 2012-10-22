class Actividad < ActiveRecord::Base
  include Openwolf::Actividad

  attr_accessible :textoactividad, :usuario_id, :institucion_id
  attr_accessor :dont_send_email

  belongs_to :solicitud
  belongs_to :usuario
  belongs_to :institucion
  belongs_to :estado

  has_many :seguimientos, :dependent => :destroy

  validates_presence_of :usuario_id, :institucion_id, :textoactividad
  validates_associated :solicitud

  before_validation(:on => :create) do
    completar_informacion
  end

  after_create :actualizar_solicitud
  after_create :notificar_asignacion
  after_destroy :actualizar_solicitud

  scope :nocompletadas, :conditions=>["fecha_resolucion IS NULL" ]
  scope :completadas, :conditions=>["fecha_resolucion IS NOT NULL" ]

end

# == Schema Information
#
# Table name: actividades
#
#  id               :integer          not null, primary key
#  institucion_id   :integer          not null
#  usuario_id       :integer          not null
#  fecha_asignacion :date             not null
#  textoactividad   :text             not null
#  estado_id        :integer          default(1), not null
#  fecha_resolucion :date
#  created_at       :datetime
#  updated_at       :datetime
#  solicitud_id     :integer          not null
#

