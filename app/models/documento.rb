class Documento < ActiveRecord::Base
  include Openwolf::Archivo::Documento

  attr_accessible :id, :numero, :origen_id, :documentoclasificacion_id, \
  :documentocategoria_id, :fecha_documento, :autor_id, :asunto, :texto, \
  :fecha_recepcion, :remitente_nombre, :remitente_direccion, :remitente_telefonos, \
  :remitente_email, :estado_envio_id, :original, :usuario_id, :institucion_id, \
  :parent_id, :created_at, :updated_at, :archivo_id

  acts_as_nested_set

  before_validation(:on => :create) do
    completar_informacion
  end

  belongs_to :institucion
  belongs_to :documentocategoria
  belongs_to :documentoclasificacion
  belongs_to :autor, :class_name => "Usuario", :foreign_key => :autor_id
  belongs_to :usuario
  belongs_to :institucion
  belongs_to :archivo

  has_many :documentotraslados, :dependent => :destroy

  validates_presence_of :numero, :fecha_documento, :asunto, :texto
  validates_uniqueness_of :numero


  default_scope :include => [:documentoclasificacion, :documentocategoria, :autor, :usuario, :institucion]

end

# == Schema Information
#
# Table name: documentos
#
#  id                        :integer          not null, primary key
#  numero                    :string(255)      not null
#  origen_id                 :integer          default(1), not null
#  documentoclasificacion_id :integer          not null
#  documentocategoria_id     :integer          not null
#  fecha_documento           :date             not null
#  autor_id                  :integer          not null
#  asunto                    :string(255)      not null
#  texto                     :text
#  fecha_recepcion           :date
#  remitente_nombre          :string(255)
#  remitente_direccion       :text
#  remitente_telefonos       :string(255)
#  remitente_email           :string(255)
#  estado_envio_id           :integer          default(1), not null
#  original                  :boolean          not null
#  usuario_id                :integer          not null
#  institucion_id            :integer          not null
#  parent_id                 :integer
#  lft                       :integer
#  rgt                       :integer
#  created_at                :datetime
#  updated_at                :datetime
#  archivo_id                :integer
#

