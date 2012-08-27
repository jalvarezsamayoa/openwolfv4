class Admin::RolesController < InheritedResources::Base
  respond_to :html
  defaults :route_prefix => 'admin'
  before_filter :authenticate_usuario!
  load_and_authorize_resource
  before_filter :set_home_breadcrumb

  add_crumb("Roles Seguridad") { |instance| instance.send :admin_roles_path }

  def index
    @roles = Role.name_like(params[:search]).paginate(:page => params[:page])
  end



end
