class Admin::DepartamentosController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Departamentos") { |instance| instance.send :admin_departamentos_path }

  def index
    @departamentos = Departamento.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
