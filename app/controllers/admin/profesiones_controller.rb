class Admin::ProfesionesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Profesiones") { |instance| instance.send :admin_profesiones_path }

  def index
    @profesiones = Profesion.nombre_like(params[:search]).paginate(:page => params[:page])
  end


end
