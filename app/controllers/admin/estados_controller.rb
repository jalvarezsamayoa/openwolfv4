class Admin::EstadosController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Estados Solicitud") { |instance| instance.send :admin_estados_path }


  def index
    @estados = Estado.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
