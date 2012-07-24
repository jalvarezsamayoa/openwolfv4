class EstadosController < InheritedResources::Base
  respond_to :html
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Estados Solicitud") { |instance| instance.send :estados_path }


  def index
    @estados = Estado.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
