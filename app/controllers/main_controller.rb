class MainController < ApplicationController
  before_filter :authenticate_usuario!

  def index
      @noasignadas = current_usuario.institucion.solicitudes.activas.noasignadas.recientes.correlativo.count
      @entramite = current_usuario.institucion.solicitudes.activas.asignadas.nocompletadas.recientes.correlativo.count
      @terminadas = current_usuario.institucion.solicitudes.activas.completadas.conresolucionfinal.noentregadas.recientes.correlativo.count
      @pendresolucion = current_usuario.institucion.solicitudes.activas.completadas.sinresolucionfinal.recientes.correlativo.count
  end

end
