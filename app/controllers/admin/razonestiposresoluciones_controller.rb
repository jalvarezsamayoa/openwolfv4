# encoding: utf-8
class Admin::RazonestiposresolucionesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Razón Resoluciones") { |instance| instance.send :admin_razonestiposresoluciones_path }


  def index
    @razonestiposresoluciones = Razontiporesolucion.nombre_like(params[:search]).paginate(:page => params[:page])
  end


end
