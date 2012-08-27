# solicitudes.js.coffee

jQuery ($) ->

  #= # observe_field(:solicitud_departamento_id, :url => actualizar_municipios_solicitudes_path, :with => "departamento_id", :method => :get)
  $("#solicitud_departamento_id").change ->

    # make a POST call and replace the content
    depto_id = $(this).val()
    $.ajax
      type: "GET"
      url: "/solicitudes/actualizar_municipios.js"
      data: "departamento_id=" + depto_id
      dataType: "script"



  # observer para actualizacion de usuarios en popup de asignacion de actividades
  # @view actividades/_form.html.haml
  # observe_field(:actividad_institucion_id, :url => actualizar_usuarios_actividades_path, :with => "institucion_id", :method => :get)
  $("#actividad_institucion_id").live "change", ->

    # make a POST call and replace the content
    institucion_id = $(this).val()
    $.ajax
      type: "GET"
      url: "/laip/actividades/actualizar_usuarios.js"
      data: "institucion_id=" + institucion_id
      dataType: "script"

  # bloquear la forma de solcitudes para evitar doble creacion de la solicitud
  $("form#new_solicitud").live "submit", (event) ->
    form = $(this)
    form.block message: "<h2><img src=\"/images/ajax-loader.gif\"/> Procesando...</h2>"

  $("form.edit_solicitud").live "submit", (event) ->
    form = $(this)
    form.block message: "<h2><img src=\"/images/ajax-loader.gif\"/> Procesando...</h2>"