class Admin::MunicipiosController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Municipios") { |instance| instance.send :admin_municipios_path }

  def index
    @municipios = Municipio.nombre_like(params[:search]).paginate(:page => params[:page])
  end


end
