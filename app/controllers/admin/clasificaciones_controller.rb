class Admin::ClasificacionesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Clasificaciones") { |instance| instance.send :admin_clasificaciones_path }


  # GET /clasificaciones
  # GET /clasificaciones.xml
  def index
    @clasificaciones = Clasificacion.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
