class Admin::ImportarController < ApplicationController
  before_filter :authenticate_usuario!
  authorize_resource :class => false
  before_filter :set_home_breadcrumb

  add_crumb("Importar Datos")


  def index
    @instituciones = Institucion.order('nombre')
  end

  def create

    TempAsset.delete_all

    @tmpasset = TempAsset.new(:institucion_id => params[:institucion_id],
                              :usuario_id => current_usuario.id,
                               :archivo => params[:archivo],
                               :options => Marshal.dump(params[:campos]) )

    @tmpasset.save!
    @tmpasset.importar_archivo

    flash[:notice] = "Importando archivo..."

    redirect_to admin_status_importar_path(1)
  end


  def status
#    @tmpasset = TempAsset.find(params[:id])
    @log = WorkerLog.limit(15)
  end
end
