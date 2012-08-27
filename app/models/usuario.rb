# -*- coding: utf-8 -*-
class Usuario < ActiveRecord::Base
  # configuracion plugin vestal_versions
  # provee log de cambios excepto en los siguientes campos
  # versioned :except => [:password, :last_request_at, :sing_in_count,
  #                       :failed_attempts, :current_sing_int_at,
  #                       :last_sign_in_ip]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, \
  :nombre, :cargo, :departamento_id, :areadocumento_id, :puesto_id, \
  :institucion_id, :essupervisorarea, :username, :role_ids, :login, :activo

  # configuracion plugin acl9
  # agrega funcion usuario.has_role?
  acts_as_authorization_subject  :association_name => :roles, :join_table_name => "roles_usuarios"

  ############
  # Relaciones
  ############

  belongs_to :institucion

  has_and_belongs_to_many :roles, :join_table => "roles_usuarios"

  has_many :actividades
  has_many :solicitudes
  has_many :documentos
  has_many :documentotraslados
  has_many :documentostrasladados, :class_name => "Documentotraslado", :foreign_key => "destinatario_id"

  ###############
  # Validaciones
  ###############

  validates_associated :institucion
  accepts_nested_attributes_for :roles

  validates_presence_of :nombre, :email, :cargo, :institucion_id
  validates_uniqueness_of :nombre, :email

  before_destroy :puede_borrar?

      #---------------------------------
      # Callbacks
      #---------------------------------

  before_validation(on: :create) do
    cargar_predeterminados
  end

  def puede_borrar?
    check_for_children({:actividades => "Actividades", :solicitudes => "Solicitudes", :documentos => "Documentos"})
  end


  #################
  # Filtros
  #################

#  default_scope :include => :institucion, :order => "activo desc, instituciones.nombre asc, usuarios.nombre asc"

  scope :udip, :joins => :roles, :conditions => "roles.name = 'userudip' or roles.name = 'superudip'"
  scope :supervisores, :joins => :roles, :conditions => "roles.name = 'superudip'"
  scope :enlaces, :joins => :roles, :conditions => "roles.name = 'userudip' or roles.name = 'superudip' or roles.name = 'enlace'"
  scope :ciudadanos, :joins => :roles, :conditions => "roles.name = 'ciudadano'"
  scope :activos, where("usuarios.activo = ?",true)

  scope :nombre_like, lambda { |nombre|
    valor = '%'+nombre+'%'
    where("usuarios.email ilike ? or usuarios.username ilike ? or usuarios.nombre ilike ? or usuarios.cargo ilike ? or instituciones.nombre ilike ?", valor, valor, valor, valor, valor ).includes(:institucion)
  }

  ###############################
  # Metodos publicos de Instancia
  ###############################

  # metodo auxiliar para plugin Formtastic
  def to_label
    nombre_cargo
  end

  # retorna combinacion de nombre real de usuario mas su cargo
  def nombre_cargo
    return nombre + ', ' + cargo
  end

  # retorna combinacion de nombre real de usuario mas nombre de
  # institucion donde labora
  def nombre_institucion
    return nombre + ' en ' + institucion.nombre
  end

  ################################
  # Metodos protegidos
  ################################

  private

  def cargar_predeterminados
    self.username = self.email if self.username.blank?
  end

end

# == Schema Information
#
# Table name: usuarios
#
#  id                     :integer          not null, primary key
#  username               :string(255)
#  email                  :string(255)      default(""), not null
#  nombre                 :string(255)
#  cargo                  :string(255)
#  puesto_id              :integer
#  institucion_id         :integer
#  essupervisorarea       :boolean
#  encrypted_password     :string(255)      default(""), not null
#  sign_in_count          :integer
#  failed_attempts        :integer
#  last_request_at        :datetime
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  genero                 :boolean          default(FALSE)
#  fecha_nacimiento       :date
#  direccion              :string(255)      default("No Disponible"), not null
#  telefonos              :string(255)      default("No Disponible"), not null
#  openid_identifier      :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  reset_password_token   :string(255)
#  remember_token         :string(255)
#  remember_created_at    :datetime
#  unlock_token           :string(255)
#  locked_at              :datetime
#  activo                 :boolean          default(TRUE)
#  reset_password_sent_at :datetime
#

