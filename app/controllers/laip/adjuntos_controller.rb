class Laip::AdjuntosController < ApplicationController
  respond_to :html, :js

  before_filter :authenticate_usuario!, :except => [:download]
  load_and_authorize_resource


  def new
    obtener_proceso
    @adjunto = @proceso.adjuntos.new()

    @adjunto.informacion_publica = @proceso.informacion_publica

    @usa_solicitudes_privadas = current_usuario.institucion.usasolicitudesprivadas

    respond_to do |format|
      format.js
    end
  end

  def create
    obtener_proceso
    @adjunto = @proceso.adjuntos.new(params[:adjunto])
    @adjunto.usuario_id = current_usuario.id
    @adjunto.numero = @adjunto.archivo_file_name if @adjunto.numero.empty?

    respond_to do |format|
      if @adjunto.save
        @adjuntos = @proceso.adjuntos
        flash[:notice] = 'Adjunto grabado con exito.'
        format.js { responds_to_parent {render} }
      else
        flash[:error] = 'Ha ocurrido un error al grabar el adjunto.'
        format.js { responds_to_parent {render 'error'} }
      end
    end #respond_to

  end

  def destroy

    obtener_proceso
    @adjunto = @proceso.adjuntos.find(params[:id])
    @adjunto.destroy

    @adjuntos = @proceso.adjuntos

    flash[:success] = 'Adjunto eliminado con exito.'

    respond_to do |wants|
      wants.html { redirect_to institucion_solicitud_path(@proceso.institucion_id, @proceso.id) }
      wants.js
    end
  end

  def download
    head(:not_found) and return if (@adjunto = Adjunto.find_by_id(params[:id])).nil?
    head(:forbidden) and return unless @adjunto.puede_descargar?(current_usuario)

    send_file @adjunto.archivo.path, :type => @adjunto.archivo_content_type

  end

  private

  def obtener_proceso
    if params[:solicitud_id]
      @proceso = current_usuario.institucion.solicitudes.find(params[:solicitud_id])
    elsif params[:seguimiento_id]
      @proceso = current_usuario.institucion.seguimientos.find(params[:seguimiento_id])
    else
      raise 'Se han recibido parametros no validos.'
    end
  end
end
