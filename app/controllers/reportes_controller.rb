# -*- coding: utf-8 -*-
class ReportesController < ApplicationController
  before_filter :authenticate_usuario!
  respond_to :html, :xml, :csv, :pdf

  #displays pdf report with vendors balance
  def solicitudes
    report = SolicitudesReport.new(:page_size => 'LEGAL',
                                   :page_layout => :landscape)
    report.reporttitle  = 'REPORTES DE SOLICITUDES'
    report.items = Solicitud.find(:all, :conditions => ["solicitudes.institucion_id = ? and solicitudes.anulada = ?", current_usuario.institucion_id, false], :order => :numero)
    output = report.to_pdf

    file_name = "solicitudes_" + Time.now.to_i.to_s + ".pdf"

    respond_to do |format|
      format.pdf do
        send_data output, :filename => file_name,
          :type => "application/pdf"
      end
    end
  end

  def solicitudes_xml
    @solicitudes = Solicitud.where("solicitudes.institucion_id = ? and solicitudes.anulada = ?", current_usuario.institucion_id, false).order(:numero)

    # respond_to do |format|
    #   format.xml  { render :xml => @solicitudes.to_xml(:include => Solicitud.xml_options ) }
    # end
    xml_string = @solicitudes.to_xml(:include => Solicitud.xml_options )
    file_name = "solicitudes_" + Time.now.strftime("%Y-%m-%d-%H%M%S") + ".xml"

    send_data xml_string, :type => "text/plain",
      :filename=>file_name,
      :disposition => 'attachment'
  end

  def solicitudes_csv
    @institucion = current_usuario.institucion


    if params[:desde] and params[:hasta]
      institucion_nombre = current_usuario.institucion.abreviatura
      csv_string = Solicitud.export_to_csv(:institucion_id => current_usuario.institucion_id,
                                           :desde => params["desde"],
                                           :hasta => params["hasta"])
      send_data csv_string, :type => "text/plain",
        :filename=>"reporte_solicitudes_#{institucion_nombre}_#{Time.now.to_i}.csv",
        :disposition => 'attachment'
    else
      min_ano = Solicitud.minimum(:fecha_creacion).year
      @anos = (min_ano..Date.today.year).to_a
    end
  end

  def instituciones_activas
    @instituciones = Institucion.activas.paginate(:page => params[:page])
  end

  def parametros_fecha
  end

  #   Reporte de solicitudes ingresadas por rango de fecha
  def solicitudes_ingresadas

    if params[:desde] and params[:hasta]
      institucion_nombre = current_usuario.institucion.abreviatura

      d_desde = Date.new(params[:desde][2].to_i, params[:desde][1].to_i, params[:desde][0].to_i)
      d_hasta = Date.new(params[:hasta][2].to_i, params[:hasta][1].to_i, params[:hasta][0].to_i)

      @solicitudes = Solicitud.ingresadas(d_desde, d_hasta)
    end

    respond_to do |format|
      format.html { render :parametros_fecha }
      format.pdf do
        render :pdf => "solicitudes_ingresadas_#{Time.now.to_i}", \
        :layout => "print.html", \
        :page_size => "Legal", \
        :orientation => "Landscape", \
        :disposition=> 'attachment',
        :encoding => 'UTF-8'
      end
    end
  end

  # Reporte de solicitudes por estatus y días de respuesta pendiente
  def solicitudes_por_estado
  end

  # Resoluciones emitidas por rango de recha y tipo de resolución
  def resoluciones_emitidas
  end

  # Reporte de solicitudes con atraso en tiempo
  def solicitudes_atrasadas
  end

  # Reportes por diversos criterios de información estadística
  def estadisticas
  end

  # Gerencial (Usuarios SuperAdmin)
  # Solicitudes ingresadas por rango de fecha por Institución o todas las instituciones.
  # Solicitudes con atraso (todas las instituciones).
  # Solicitudes por estatus por rango de fecha.


end
