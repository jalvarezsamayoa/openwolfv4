class ActividadesController < ApplicationController
  before_filter :authenticate_usuario!
  before_filter :get_data, :except =>[:marcar_como_completada, :index, :actualizar_usuarios]
  before_filter :obtener_privilegios, :only => [:show, :create]

  def index
    # @asignaciones = current_usuario.actividades
    @asignaciones = current_usuario.actividades.paginate(:page => params[:page])
  end

  def show
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # GET /actividades/new
  # GET /actividades/new.xml
  def new
    @actividad = current_usuario.institucion.actividades.new
    @instituciones = current_usuario.institucion.familia_activa
    respond_to do |format|
      format.js
    end
  end

  # GET /actividades/1/edit
  def edit
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  # POST /actividades
  # POST /actividades.xml
  def create
    @actividad = @solicitud.actividades.new(params[:actividad])
    @actividades = @solicitud.actividades

    respond_to do |format|
      if @actividad.save
        flash[:success] = 'Asignacion creada con exito.'
        format.js
      else
        @actividad.institucion_id = current_usuario.institucion_id
        @instituciones = current_usuario.institucion.familia
        @usuarios = @institucion.usuarios.enlaces

        flash[:error] = 'Asignacion fallida.'
        format.js do
          render :failed
        end
      end
    end
  end

  # PUT /actividades/1
  # PUT /actividades/1.xml
  def update
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      if @actividad.update_attributes(params[:actividad])
        flash[:notice] = 'Actividad was successfully updated.'
        format.html { redirect_to(@actividad) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @actividad.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /actividades/1
  # DELETE /actividades/1.xml
  def destroy
    @actividad = Actividad.find(params[:id])
    @actividad.destroy

    respond_to do |format|
      format.html { redirect_to(institucion_solicitud_url(@institucion,@solicitud)) }
      format.xml  { head :ok }
    end
  end

  #cambia estado de actividad
  def marcar_como_completada
    @actividad = Actividad.find(params[:id])

    respond_to do |format|
      if @actividad.marcar_como_terminada
        flash[:success] = 'Asignacion marcada como Completada.'
      else
        c_errores = "Asignacion no pudo ser actualizada. "
        @actividad.errors.full_messages.each do |msg|
          c_errores += msg + ". "
        end
        @actividad.solicitud.errors.full_messages.each do |msg|
          c_errores += msg + ". "
        end

        flash[:error] = c_errores
      end

      @solicitud = @actividad.solicitud
      @asignaciones = current_usuario.actividades.nocompletadas

      format.html { redirect_to solicitud_path(@solicitud) }
    end
  end

  def actualizar_usuarios
    institucion = Institucion.find(params[:institucion_id])
    if institucion.id == current_usuario.institucion_id
      @usuarios = institucion.usuarios.activos.enlaces
    else
      @usuarios = institucion.usuarios.activos.supervisores
    end
    respond_to do |format|
      format.js do
        render :actualizar_usuarios
      end
    end
  end

  private


  def obtener_privilegios
    @es_pertinente_a_usuario = @solicitud.es_pertinente?(current_usuario)
    # @usuario_es_supervisor =  nivel_seguridad(current_usuario,'encargadoudip')
    @usuario_es_udip = nivel_seguridad(current_usuario,'personaludip')
    @puede_remover_asignacion = (@es_pertinente_a_usuario && @usuario_es_udip)
  end

  def get_data
    @institucion = current_usuario.institucion
    @solicitud = Solicitud.find(params[:solicitud_id])
    @usuarios = @institucion.usuarios.activos.enlaces
  end
end
