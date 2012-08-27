# encoding: utf-8
class Laip::SolicitudesController < ApplicationController
  respond_to :html, :js

  before_filter :authenticate_usuario!, :except => [:print]
  load_and_authorize_resource
  before_filter :set_home_breadcrumb
  add_crumb("Solicitudes y Tareas", :except => [:index])  { |instance| instance.send :laip_solicitudes_path }


  before_filter :get_institucion, :except => [:cambiar_estado, \
                                              :actualizar_estado, \
                                              :marcar_entregada, \
                                              :print]
  before_filter :get_data, :except => [:find, :print]


  # GET /solicitudes
  # GET /solicitudes.xml
  def index
    #@solicitudes = Solicitud.all

    @usuario_es_udip = nivel_seguridad(current_usuario,'personaludip')

    if @usuario_es_udip

      @noasignadas = current_usuario.institucion.solicitudes.activas.noasignadas.recientes.correlativo
      @entramite = current_usuario.institucion.solicitudes.activas.asignadas.nocompletadas.recientes.correlativo

      @terminadas = current_usuario.institucion.solicitudes.activas.completadas.conresolucionfinal.noentregadas.recientes.correlativo

      @pendresolucion = current_usuario.institucion.solicitudes.activas.completadas.sinresolucionfinal.recientes.correlativo

      @entregadas = current_usuario.institucion.solicitudes.activas.entregadas.recientes.correlativo.limit(50)
      @entregadas_cnt = current_usuario.institucion.solicitudes.activas.entregadas.recientes.correlativo.count


      @anuladas = current_usuario.institucion.solicitudes.anuladas

    else
      @noasignadas = nil
      @entramite = nil
      @terminadas = nil
      @pendresolucion = nil
      @entregadas = nil
      @anuladas = nil
    end

    @asignaciones = current_usuario.actividades.nocompletadas

    @current_tab = (params[:tab] ? params[:tab] : nil)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @solicitudes }
    end
  end

  def refresh_tab
    @refresh_tab = params[:tab]

    case @refresh_tab
    when "#no-asignadas"
      @noasignadas = current_usuario.institucion.solicitudes.activas.noasignadas.recientes.correlativo
      @with_partial = 'noasignadas'
     when "#en-tramite"
      @entramite = current_usuario.institucion.solicitudes.activas.asignadas.nocompletadas.recientes.correlativo
      @with_partial = 'entramite'
     when "#pendientes-resolucion"
      @pendresolucion = current_usuario.institucion.solicitudes.activas.completadas.sinresolucionfinal.recientes.correlativo
      @with_partial = 'pendientesresolucion'
     when "#terminadas"
      @terminadas = current_usuario.institucion.solicitudes.activas.completadas.conresolucionfinal.noentregadas.recientes.correlativo
      @with_partial = 'terminadas'
    when "#entregadas"
      @entregadas = current_usuario.institucion.solicitudes.activas.entregadas.recientes.correlativo.limit(50)
      @with_partial = 'entregadas'
    when "#anuladas"
      @anuladas = current_usuario.institucion.solicitudes.anuladas
      @with_partial = 'anuladas'
    else "tareas"
      @with_partial = nil
    end

    respond_to do |format|
      format.js
    end
  end


  # GET /solicitudes/1
  # GET /solicitudes/1.xml
  def show

    @solicitud = @institucion.solicitudes.find(params[:id])
    @actividades = @solicitud.actividades
    @adjuntos = @solicitud.adjuntos

    @es_pertinente_a_usuario = @solicitud.es_pertinente?(current_usuario)
    @usuario_es_supervisor =  nivel_seguridad(current_usuario,'encargadoudip')
    @usuario_es_udip = nivel_seguridad(current_usuario,'personaludip')

    @mostrar_datos_solicitante = (@es_pertinente_a_usuario and (@usuario_es_supervisor or @usuario_es_udip))

    # es posible remover una asignacion si
    # 1. el usuario tiene el nivel
    # 2. si la solicitud no esta en un Estado FINAL
    @puede_remover_asignacion = ( (@es_pertinente_a_usuario and @usuario_es_udip) and !@solicitud.con_resolucion_final?)


    @restringir_seguimientos_privados = !(@es_pertinente_a_usuario && @usuario_es_udip)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @solicitud }
    end
  end


  # GET /solicitudes/new
  # GET /solicitudes/new.xml
  def new
    @solicitud = @institucion.solicitudes.new
    @usa_solicitudes_privadas = current_usuario.institucion.usasolicitudesprivadas
    add_crumb "Nueva Solicitud"
  end

  # POST /solicitudes
  # POST /solicitudes.xml
  def create

    @solicitud = @institucion.solicitudes.new(params[:solicitud])
    @solicitud.usuario_id = current_usuario.id
    @solicitud.origen_id = Solicitud::ORIGEN_DEFAULT

    #limpiamos fecha de creacion pasandola a formato MM/DD/YYYY
    @solicitud.fecha_creacion = fix_date(params[:solicitud][:fecha_creacion])

    respond_to do |format|
      if @solicitud.save
        flash[:success] = 'Solicitud creada con exito.'
        format.html { redirect_to laip_solicitud_path(@solicitud) }
        format.xml  { render :xml => @solicitud, :status => :created, :location => @solicitud }
      else
        logger.debug { "Error #{@solicitud.errors.inspect}" }
        format.html { render :action => "new" }
        format.xml  { render :xml => @solicitud.errors, :status => :unprocessable_entity }
      end
    end
  end




  # GET /solicitudes/1/edit
  def edit
    @solicitud = Solicitud.find(params[:id])
    @solicitud.fecha_creacion = l(@solicitud.fecha_creacion)
    add_crumb("Solicitud", laip_solicitud_path(@solicitud))
    add_crumb "Editar Solicitud"
  end


  # PUT /solicitudes/1
  # PUT /solicitudes/1.xml
  def update
    @solicitud = Solicitud.find(params[:id])

    #limpiamos fecha de creacion pasandola a formato MM/DD/YYYY
    params[:solicitud][:fecha_creacion] = fix_date(params[:solicitud][:fecha_creacion]) if params[:solicitud][:fecha_creacion]

    respond_to do |format|
      if @solicitud.update_attributes(params[:solicitud])
        flash[:notice] = 'Solicitud actualizada con exito.'
        format.html { redirect_to institucion_solicitud_path(@institucion, @solicitud) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @solicitud.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /solicitudes/1
  # DELETE /solicitudes/1.xml
  def destroy
    @solicitud = Solicitud.find(params[:id])
    @solicitud.anular

    respond_to do |format|
      flash[:success] = "Solicitud ha sido anulada"
      format.html { redirect_to(laip_solicitud_url(@solicitud)) }
      format.xml  { head :ok }
    end
  end

  #inicia ciclo para cambio de estado
  def cambiar_estado
    @solicitud = Solicitud.find(params[:id])
    @estados = Estado.all(:order => 'nombre')
    respond_to do |format|
      format.js
    end
  end

  #actualiza el estado de la solicitud
  def actualizar_estado
    @solicitud = Solicitud.find(params[:id])

    respond_to do |format|
      format.js do
        if @solicitud.update_attributes(params[:solicitud])
          flash[:success] = 'Estado actualizado con exito.'
        end
      end
    end

  end

  #marcar como entregada
  def marcar_entregada
    @solicitud = Solicitud.find(params[:id])
    @solicitud.solicitud_entregada
    respond_to do |format|
      format.html do
        flash[:notice] = 'Solicitud fue marcada como entregada.'
        redirect_to solicitud_url(@solicitud)
      end
    end
  end


  #imprime en pdf
  def print
    @solicitud = Solicitud.find(params[:id])

    if current_usuario
      @es_pertinente_a_usuario = @solicitud.es_pertinente?(current_usuario)
      @usuario_es_supervisor =  nivel_seguridad(current_usuario,'encargadoudip')
      @usuario_es_udip = nivel_seguridad(current_usuario,'personaludip')

      @mostrar_datos_solicitante = (@es_pertinente_a_usuario and (@usuario_es_supervisor or @usuario_es_udip))
    else
      @mostar_datos_solicitante = false
    end

    respond_to do |format|
      format.pdf do
        render :pdf => "solicitud", \
          :layout => "layouts/print", \
          :template => "portal/solicitud.html.haml", \
          :disposition => 'attachment',
          :encoding => "utf8"
      end
    end

  end

  def actualizar_municipios
    depto = Departamento.find(params[:departamento_id])
    @municipios = depto.municipios
    respond_to do |format|
      format.js do
        render :actualizar_municipios
      end
    end
  end

  #busca solicitudes
  def find
    # si no se esta solicitando un filtro
    # solo mostramos las solicitudes de la institucion
    # del usuario actual
    params[:institucion_id] = current_usuario.institucion_id unless (params[:filtrar] or current_usuario_admin?)

    # guardamos el estado del filtro para agregarlo a la paginacion
    if params[:filtrar]
      @filtros = params
    else
      @filtros = nil
    end

    params[:anuladas] = true

    @busqueda = Busqueda.new(params)

    @solicitudes = @busqueda.solicitudes

    @desde = @busqueda.fecha_desde
    @hasta = @busqueda.fecha_hasta

    @q = @busqueda.q

    @url = buscar_path

  end

  private

  def get_institucion
    @institucion = current_usuario.institucion
  end

  def get_data
    @vias = Via.all
    @municipios = Departamento.first.municipios.all(:order => "municipios.nombre")
  end



end
