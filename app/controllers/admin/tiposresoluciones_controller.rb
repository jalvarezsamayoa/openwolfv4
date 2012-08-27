class Admin::TiposresolucionesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Tipos de Resoluciones") { |instance| instance.send :admin_tiposresoluciones_path }


  # GET /tiposresoluciones
  # GET /tiposresoluciones.xml
  def index
    @tiposresoluciones = Tiporesolucion.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
