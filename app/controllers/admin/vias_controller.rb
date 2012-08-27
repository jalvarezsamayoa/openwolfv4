class Admin::ViasController <  InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Via de Solicitudes") { |instance| instance.send :admin_vias_path }

  def index
    @vias = Via.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
