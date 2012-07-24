class RolesController < InheritedResources::Base
  respond_to :html
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Roles Seguridad") { |instance| instance.send :roles_path }

  def index
    @roles = Role.name_like(params[:search]).paginate(:page => params[:page])
  end



end
