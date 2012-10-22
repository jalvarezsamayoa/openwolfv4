class Documentotraslado < ActiveRecord::Base
  include Openwolf::Archivo::Traslado

  belongs_to :institucion #del documento
  belongs_to :usuario #quien genero el traslado
  belongs_to :destinatario, :class_name => "Usuario", :foreign_key => "destinatario_id"
  belongs_to :documento #original que se traslada
  belongs_to :documentodestino, :class_name => "Documento", :foreign_key => "documento_destinatario_id"

  before_create :crear_documento

end

# == Schema Information
#
# Table name: documentotraslados
#
#  id                        :integer          not null, primary key
#  institucion_id            :integer          not null
#  usuario_id                :integer          not null
#  destinatario_id           :integer          not null
#  documento_id              :integer          not null
#  documento_destinatario_id :integer          not null
#  original                  :boolean          default(FALSE)
#  estado_entrega_id         :integer          default(1), not null
#  fecha_envio               :datetime
#  fecha_respuesta           :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  descripcion               :text
#

