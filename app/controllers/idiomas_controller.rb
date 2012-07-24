class IdiomasController < InheritedResources::Base
  respond_to :html
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Idiomas") { |instance| instance.send :idiomas_path }

  # GET /idiomas
  # GET /idiomas.xml
  def index
    @idiomas = Idioma.nombre_like(params[:search]).paginate(:page => params[:page])
  end

end
