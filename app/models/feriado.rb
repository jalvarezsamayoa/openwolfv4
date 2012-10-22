class Feriado < ActiveRecord::Base
  include Openwolf::Core::Feriado

  attr_accessible :nombre, :dia, :mes, :institucion_id, :tipoferiado_id, :fecha


  validates :nombre, :uniqueness => true, :presence => true
  validates :dia, :presence => true
  validates :mes, :presence => true
  validates :tipoferiado_id, :presence => true
  validates :institucion, :associated => true

  belongs_to :institucion

  before_validation :cleanup

  default_scope :order => "feriados.mes asc, feriados.dia asc"
  scope :nacional, where("tipoferiado_id = ?",TIPO_NACIONAL)
  scope :local, where("tipoferiado_id = ?",TIPO_LOCAL)

  scope :nombre_like, lambda { |nombre|
    unless nombre.nil? || nombre.empty? || nombre.first.nil?
      valor = "%#{nombre}%".upcase
      where("UPPER(feriados.nombre) like ?", valor )
    end
  }

  scope :por_institucion, lambda {|institucion_id|
    where("institucion_id = ?",institucion_id)
  }

  scope :en_fecha, lambda {|fecha|
    fecha = fecha.tr('/','-').to_date unless fecha.class == Date
    a_fecha = [fecha.year, fecha.month, fecha.day]
    where("dia = ? and mes = ?",a_fecha[2], a_fecha[1])
  }

  scope :entre_fechas, lambda {|desde, hasta|
    desde = desde.tr('/','-').to_date unless desde.class == Date
    hasta = hasta.tr('/','-').to_date unless hasta.class == Date

    if desde.year == hasta.year
      where("fecha between ? and ?", desde, hasta)
    else
      ultimo_dia_ano = Date.civil(desde.year,12,31)
      primer_dia_ano = Date.civil(desde.year,1,1)
      hasta = (hasta << 12)
      where("(fecha between ? and ?) or (fecha between ? and ?)", desde, ultimo_dia_ano, primer_dia_ano, hasta)
    end
  }




end

# == Schema Information
#
# Table name: feriados
#
#  id             :integer          not null, primary key
#  nombre         :string(255)      not null
#  dia            :integer          default(1), not null
#  mes            :integer          default(1), not null
#  institucion_id :integer          default(1), not null
#  tipoferiado_id :integer          default(1), not null
#  created_at     :datetime
#  updated_at     :datetime
#  fecha          :date
#

