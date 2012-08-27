# encoding: utf-8
module SolicitudesHelper

  def solicitud_dias_restantes_badge(solicitud)

    if solicitud.atrasada?
      badge = 'badge-important'
    elsif solicitud.terminada?
      badge = 'badge-success'
    else
      badge = ''
    end

    raw content_tag(:span, solicitud.dias_restantes, :class => "badge #{badge}")
  end

  def solicitud_boton_regresar

    raw(link_to(image_tag('undo16.png') + t("data.back"),
                solicitudes_path,
                :class => 'button' )
        )
  end

  def solicitud_boton_imprimir(solicitud, mostrar = true)
    return nil if !mostrar or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to(print_portal_url(@solicitud, :format => 'pdf'), :target=>:blank)  do
        raw "<i class='icon-print icon-white'></i> Imprimir"
      end
    end
    link
  end

  def solicitud_boton_editar(solicitud, pertinente = false, supervisor = false)
    return nil if !(pertinente && supervisor) or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to( edit_laip_solicitud_path(solicitud)) do
        raw "<i class='icon-edit icon-white'></i> #{t("data.edit")}"
      end
    end
    link
  end

  def solicitud_boton_eliminar(solicitud, pertinente = false, supervisor = false)
    return nil if !(pertinente && supervisor) or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to(laip_solicitud_path(solicitud),
              :confirm => t("data.rusure"),
              :method => :delete,
      :title => "Anular solicitud") do
        raw "<i class='icon-trash icon-white'></i> Anular Solicitud"
      end

    end
    link
  end

  def solicitud_boton_asignar_enlace(solicitud, pertinente = false, udip = false)
    return nil if !(!solicitud.entregada? && pertinente && udip) or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to(   new_laip_solicitud_actividad_path(solicitud),
                 :title => 'Asignar solicitud a responsable',
                 :method => :get,
      :remote => true ) do
        raw "<i class='icon-user icon-white'></i> #{t("actividades.title_new")}"
      end
    end
    link
  end

  def solicitud_boton_adjuntar_documento(solicitud, pertinente = false, udip = false)
    return nil if !(pertinente && udip) or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to( new_laip_solicitud_adjunto_path(@solicitud),
               :title => 'Adjuntar archivos a Solicitud',
               :method => :get,
      :remote => true ) do
        raw "<i class='icon-file icon-white'></i> #{t("solicitudes.label_adjuntaradjunto")}"
      end
    end
    link
  end

  def solicitud_boton_emitir_resolucion(solicitud, pertinente = false, supervisor = false)
    return nil if !(solicitud.asignada? && pertinente && supervisor) or solicitud.anulada?
    return nil if solicitud.entregada?
    link = content_tag(:li, nil) do
      link_to( laip_solicitud_resoluciones_path(solicitud),
      :id=>'link_new_resolucion') do
        raw "<i class='icon-check icon-white'></i> #{t("solicitudes.label_resoluciones")}"
      end
    end
    link
  end

  def solicitud_boton_recurso_revision(solicitud, pertinente = false, udip = false)
    return nil if !(solicitud.entregada? and pertinente and udip) or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to(        laip_solicitud_recursosrevision_path(solicitud),
      :id=>'link_new_recursorevision') do
        raw "<i class='icon-check icon-white'></i> #{t("solicitudes.label_recursosrevision")}"
      end
    end
    link
  end

  def solicitud_boton_seguimientos(solicitud, pertinente = false, supervisor = false)
    return nil if !(pertinente && supervisor) or solicitud.anulada?
    link = content_tag(:li, nil) do
      link_to( laip_solicitud_notas_path(solicitud),
      :title => 'Notas de Seguimiento para Solicitud') do
        raw "<i class='icon-comment icon-white'></i> #{Solicitud.human_attribute_name(:notas)}"
      end
    end
    link
  end

  def actividad_boton_agregar_seguimiento(actividad)
    return '' if actividad.solicitud.anulada?
    return '' if actividad.nil?
    link_to( new_laip_solicitud_actividad_seguimiento_path(actividad.solicitud_id,  actividad.id),
             :remote => true,
             :class => 'btn',
             :title => 'Agregar seguimiento a tareas asignada.') do
      raw "<i class='icon-plus icon-white'></i> Agregar Seguimiento"
    end
  end

  def actividad_boton_marcar_completada(actividad)
    link_to( marcar_como_completada_laip_solicitud_actividad_path(actividad.solicitud.id, actividad.id) ,
             :method => :put,
             :remote => true,
             :class => 'btn',
             :confirm => "¿Está seguro de marcar la asignación como COMPLETADA?",
             :title => 'Marcar asignación como completa.') do
      raw "<i class='icon-check icon-white'></i> Marcar como completada"
    end
  end



end
