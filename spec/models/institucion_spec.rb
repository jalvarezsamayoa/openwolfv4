require File.dirname(__FILE__) + '/../spec_helper'

describe Institucion  do
  pending
end
# == Schema Information
#
# Table name: instituciones
#
#  id                     :integer         not null, primary key
#  nombre                 :string(255)     not null
#  tipoinstitucion_id     :integer         not null
#  parent_id              :integer
#  lft                    :integer
#  rgt                    :integer
#  created_at             :datetime
#  updated_at             :datetime
#  codigo                 :string(255)     default("9999-9999"), not null
#  abreviatura            :string(255)     default("NA"), not null
#  direccion              :string(255)
#  telefono               :string(255)
#  logo_file_name         :string(255)
#  logo_content_type      :string(255)
#  logo_file_size         :integer
#  logo_updated_at        :datetime
#  activa                 :boolean         default(FALSE)
#  usasolicitudesprivadas :boolean         default(FALSE)
#  unidad_ejecutora       :string(255)
#  entidad                :string(255)
#  webpage                :string(255)
#  email                  :string(255)
#

