FactoryGirl.define do

  sequence :count do |n|
    "#{n}"
  end

  def na
    'No Disponible'
  end

  factory :institucion do |i|
    i.sequence(:nombre) {|i| "institucion_#{FactoryGirl.generate(:count)}"}
    i.tipoinstitucion_id Institucion::TIPO_MINISTERIO
    i.parent_id nil
    i.sequence(:codigo) {|i| "codigo_#{FactoryGirl.generate(:count)}"}
    i.sequence(:abreviatura) {|i| "ABR_#{FactoryGirl.generate(:count)}"}
    i.direccion { Faker::Address.street_address }
    i.telefono { Faker::PhoneNumber.phone_number }
    i.activa true
    i.usasolicitudesprivadas false
    i.unidad_ejecutora {|i| "UE_#{FactoryGirl.generate(:count)}"}
    i.entidad {|i| "ENT_#{FactoryGirl.generate(:count)}"}
    i.webpage { Faker::Internet.domain_name }
    i.email { Faker::Internet.email }
  end

  factory :genero do |genero|
    genero.sequence(:nombre) {|genero| "genero_#{FactoryGirl.generate(:count)}"}
  end

  factory :usuario do |u|
    u.sequence(:username) {|u| "usuario_#{FactoryGirl.generate(:count)}"}
    u.email { Faker::Internet.email }
    u.nombre { Faker::Name.name }
    u.cargo 'Puesto usuario'
    u.association :institucion
    u.essupervisorarea false
    u.password '123456'
    u.genero false
    u.fecha_nacimiento Date.today - 18.years
    u.direccion { Faker::Address.street_address }
    u.telefonos { Faker::PhoneNumber.phone_number }
    u.puesto_id nil
  end

  factory :clasificacion do |clasificacion|
    clasificacion.sequence(:nombre) {|clasificacion| "clasificacion_#{FactoryGirl.generate(:count)}"}
  end

  factory :documentocategoria do |dc|
    dc.sequence(:nombre) {|dc| "documentocategoria_#{FactoryGirl.generate(:count)}"}
    dc.parent_id nil
  end

  factory :documentoclasificacion do |dc|
    dc.sequence(:nombre) {|dc| "documentoclasificacion_#{FactoryGirl.generate(:count)}"}
    dc.association :documentocategoria
    dc.sequence(:codigo) { |c| "codigo_#{FactoryGirl.generate(:count)}" }
    dc.plantilla nil
  end

  factory :documentodestinatario do |dd|
    dd.association :documento
    dd.copia_id nil
    dd.association :usuario
    dd.original true
    dd.documentoestado_id Documentodestinatario::ESTADO_NOENTREGADO
    dd.association :institucion
    dd.puesto 'Nombre Puesto'
    dd.departamento 'Nombre Departamento'
  end

  factory :documento do |d|
    d.sequence(:numero) {|d| "numero_#{FactoryGirl.generate(:count)}"}
    d.origen_id Documento::ORIGEN_INTERNO
    d.association :documentoclasificacion
    d.association :documentocategoria
    d.fecha_documento Date.today
    d.association :autor, :FactoryGirl => :usuario
    d.asunto { Faker::Lorem.sentence }
    d.texto { Faker::Lorem.paragraphs }
    d.fecha_recepcion Date.today
    d.remitente_nombre { Faker::Name.name }
    d.remitente_direccion { Faker::Address.street_address }
    d.remitente_telefonos { Faker::PhoneNumber.phone_number }
    d.remitente_email { Faker::Internet.email }
    d.estado_envio_id Documento::ESTADO_BORRADOR
    d.original true
    d.association :usuario
    d.association :institucion
    d.parent_id nil
  end

  factory :estado do |estado|
    estado.sequence(:nombre) {|estado| "estado_#{FactoryGirl.generate(:count)}"}
    estado.final false
    estado.puede_entregar false
    estado.modulo_id Estado::MODULO_LAIP
  end



  factory :motivonegativa do |mn|
    mn.sequence(:nombre) {|mn| "motivonegativa_#{FactoryGirl.generate(:count)}"}
  end

  factory :motivoprorroga do |mp|
    mp.sequence(:nombre) {|mp| "motivoprorroga_#{FactoryGirl.generate(:count)}"}
  end

  factory :departamento do |departamento|
    departamento.sequence(:nombre) {|departamento| "Departamento_#{FactoryGirl.generate(:count)}"}
    departamento.sequence(:abreviatura) {|departamento| "ABR_#{FactoryGirl.generate(:count)}" }
  end

  factory :municipio do |municipio|
    municipio.sequence(:nombre) {|municipio| "Municipio_#{FactoryGirl.generate(:count)}"}
    municipio.association :departamento
  end

  factory :profesion do |p|
    p.sequence(:nombre) {|p| "profesion_#{FactoryGirl.generate(:count)}"}
  end

  factory :puesto do |p|
    p.sequence(:nombre) {|p| "puesto_#{FactoryGirl.generate(:count)}"}
    p.association :institucion
  end

  factory :rangoedad do |re|
    re.sequence(:nombre) {|re| "rangoedad_#{FactoryGirl.generate(:count)}"}
  end

  factory :razontiporesolucion do |rtr|
    rtr.sequence(:nombre) {|rtr| "razontiporesolucion_#{FactoryGirl.generate(:count)}"}
    rtr.association :tiporesolucion
    rtr.informacion_publica true
  end

  factory :recursorevision do |rr|
    rr.association :solicitud
    rr.fecha_presentacion Date.today
    rr.fecha_notifiacion Date.today
    rr.fecha_resolucion Date.today
    rr.descripcion { Faker::Lorem.sentence }
    rr.association :sentidoresolucion
    rr.association :institucion
    rr.association :usuario
    rr.sequence(:numero) {|rtr| "numero_#{FactoryGirl.generate(:count)}"}
    rr.association :documentoclasificacion
  end

  factory :resolucion do |r|
    r.sequence(:numero) {|r| "numero_#{FactoryGirl.generate(:count)}"}
    r.association :solicitud
    r.association :usuario
    r.association :institucion
    r.descripcion { Faker::Lorem.sentence }
    r.association :tiporesolucion
    r.association :razontiporesolucion
    r.nueva_fecha nil
    r.informacion_publica true
    r.association :documentoclasificacion
  end

  factory :tiporesolucion do |tr|
    tr.sequence(:nombre) {|tr| "tiporesolucion_#{FactoryGirl.generate(:count)}"}
    tr.actualiza_fecha false
    tr.associtation :estado
  end

  factory :via do |via|
    via.sequence(:nombre) {|via| "Via_#{FactoryGirl.generate(:count)}"}
  end

  factory :adjunto do |adjunto|
    adjunto.sequence(:numero) {|adjunto| "adjunto_#{FactoryGirl.generate(:count)}"}
    adjunto.observaciones { Faker::Lorem.sentence }
    adjunto.association :usuario
    adjunto.association :proceso, :factory => :solicitud
    adjunto.informacion_publica true
    adjunto.archivo File.open(Rails.root + 'spec/fixtures/documentos/documento.doc')
  end

  factory :fuente do |fuente|
    fuente.sequence(:nombre) {|fuente| "fuente_#{FactoryGirl.generate(:count)}"}
  end

  factory :solicitud do |s|
    s.association :usuario
    s.sequence(:codigo) {|n| "solicitud_#{FactoryGirl.generate(:count)}"}
    s.association :institucion
    s.association :via
    s.fecha_creacion Date.today
    s.fecha_programada Date.today + 10
    s.fecha_entregada nil
    s.fecha_resolucion nil
    s.fecha_prorroga nil
    s.fecha_completada nil
    s.solicitante_nombre { Faker::Name.name }
    s.solicitante_identificacion 'XXX-123456'
    s.solicitante_direccion { Faker::Address.street_address }
    s.solicitante_telefonos { Faker::PhoneNumber.phone_number }
    s.solicitante_institucion 'Nombre Institucion'
    s.association :departamento
    s.association :municipio
    s.email { Faker::Internet.email }
    s.forma_entrega 'Escrita'
    s.observaciones { Faker::Lorem.sentence }
    s.ubicacion_url nil
    s.estado_id Solicitud::ESTADO_NORMAL
    s.textosolicitud { Faker::Lorem.sentence }
    s.asignada false
    s.ano Date.today.year
    s.sequence(:numero) {|n| FactoryGirl.generate(:count) }
    s.association :profesion
    s.association :genero
    s.association :rangoedad
    s.association :clasificacion
    s.dias_respuesta nil
    s.dias_prorroga nil
    s.motivonegativa_id nil
    s.motivoprorroga_id nil
    s.informacion_publica true
    s.origen_id Solicitud::ORIGEN_DEFAULT
    s.association :documentoclasificacion
  end

  factory :tipomensaje do |tm|
    tm.sequence(:nombre) {|tm| "tipomensaje_#{FactoryGirl.generate(:count)}"}
  end

  factory :actividad do |actividad|
    actividad.association :institucion
    actividad.association :usuario
    actividad.fecha_asignacion Date.today
    actividad.estado_id Actividad::ESTADO_ACTIVA
    actividad.fecha_resolucion nil
    actividad.association :solicitud
    actividad.textoactividad 'No Disponible'
  end

  factory :feriado do |f|
    f.sequence(:nombre) {|f| "feriado_#{FactoryGirl.generate(:count)}"}
    f.dia 1
    f.mes 1
    f.institucion_id Institucion::ESTADO_GUATEMALA
    f.tipoferiado_id Feriado::TIPO_NACIONAL
    f.fecha Date.new(Date.today.year,1,1)
  end

  factory :idioma do |i|
    i.sequence(:nombre) {|i| "idioma_#{FactoryGirl.generate(:count)}"}
  end
end
