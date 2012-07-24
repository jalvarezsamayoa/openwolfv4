# encoding: utf-8
class RazonestiposresolucionesController < InheritedResources::Base
  respond_to :html
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Razón Resoluciones") { |instance| instance.send :razonestiposresoluciones_path }


  def index
    @razonestiposresoluciones = Razontiporesolucion.nombre_like(params[:search]).paginate(:page => params[:page])
  end


end
