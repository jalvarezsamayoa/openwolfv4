class Admin::DocumentoclasificacionesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Clasificaciones Documentales") { |instance| instance.send :admin_documentoclasificaciones_path }

  def index
    @documentoclasificaciones = Documentoclasificacion.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
