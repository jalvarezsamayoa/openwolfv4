class Admin::FuentesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Fuentes") { |instance| instance.send :admin_fuentes_path }

  def index
    @fuentes = Fuente.nombre_like(params[:search]).paginate(:page => params[:page])
  end
end
