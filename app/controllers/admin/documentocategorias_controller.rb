# encoding: utf-8
class Admin::DocumentocategoriasController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Categorías Documentales") { |instance| instance.send :admin_documentocategorias_path }


  def index
    @documentocategorias = Documentocategoria.nombre_like(params[:search]).paginate(:page => params[:page])
  end


end
