class Institucion < ActiveRecord::Base
  include Openwolf::Core::Institucion

  attr_accessible :codigo, :unidad_ejecutora, :entidad, :nombre, :abreviatura, \
  :tipoinstitucion_id, :direccion, :telefono, :activa, :usasolicitudesprivadas, \
  :email, :webpage

  #versioned
  acts_as_nested_set


  has_attached_file :logo, :styles => { :medium => "150x150>" }, :default_url   => "missing.png"

#  has_many :puestos, :dependent => :destroy
  has_many :actividades
  has_many :usuarios
  has_many :solicitudes, :dependent => :destroy
  has_many :documentos, :dependent => :destroy
  has_many :archivos, :dependent => :destroy
  has_many :seguimientos, :dependent => :destroy
  has_many :tmp_assets, :dependent => :destroy

  validates_presence_of :nombre, :message=>"Campo Nombre no puede estar vacio."
  validates_uniqueness_of :nombre, :scope => :parent_id, :message=>"Nombre ya esta en uso."


  #TODO: aberviatura debe de ser unica
  validates :abreviatura, :presence => true

  #TODO: codigo debe de ser unica
  validates :codigo, :presence => true

  validates :unidad_ejecutora, :presence => true
  validates :entidad, :presence => true

  #TODO: el email debe de ser unico
  validates :email, :presence => true

  before_validation(:on => :create) do
    cleanup
  end

  #####################
  # Filtros de busqueda
  #####################

  default_scope :order => "instituciones.nombre asc"

  scope :padres, :conditions=>["tipoinstitucion_id < ?", TIPO_INSTITUCION ], :order => :nombre
  scope :ministerios, :conditions=>["tipoinstitucion_id = ?",TIPO_MINISTERIO], :order => :nombre
  scope :instituciones, :conditions=>["tipoinstitucion_id = ?",TIPO_INSTITUCION], :order => :nombre
  scope :asignables, :conditions=>["tipoinstitucion_id = ? or tipoinstitucion_id = ?",TIPO_MINISTERIO,TIPO_INSTITUCION], :order => :nombre
  scope :activas, :conditions => ["activa = ?",true]
  scope :estado_y_activas, :conditions => ["instituciones.id = 1 or activa = ?",true]

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      valor = "%#{nombre}%".upcase
      where("UPPER(instituciones.nombre) like ? or UPPER(instituciones.codigo) like ?", valor, valor )
   end
  }


end

# == Schema Information
#
# Table name: instituciones
#
#  id                     :integer          not null, primary key
#  nombre                 :string(255)      not null
#  tipoinstitucion_id     :integer          not null
#  parent_id              :integer
#  lft                    :integer
#  rgt                    :integer
#  created_at             :datetime
#  updated_at             :datetime
#  codigo                 :string(255)      default("9999-9999"), not null
#  abreviatura            :string(255)      default("NA"), not null
#  direccion              :string(255)
#  telefono               :string(255)
#  logo_file_name         :string(255)
#  logo_content_type      :string(255)
#  logo_file_size         :integer
#  logo_updated_at        :datetime
#  activa                 :boolean          default(FALSE)
#  usasolicitudesprivadas :boolean          default(FALSE)
#  unidad_ejecutora       :string(255)
#  entidad                :string(255)
#  webpage                :string(255)
#  email                  :string(255)
#

