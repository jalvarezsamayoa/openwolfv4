class Admin::InstitucionesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :get_data
  before_filter :set_home_breadcrumb

  add_crumb("Instituciones") { |instance| instance.send :admin_instituciones_path }

  def index
    @instituciones = Institucion.nombre_like(params[:search]).order("activa desc").paginate(:page => params[:page])
  end

  private

  def get_data
    @padres = Institucion.padres
  end
end
