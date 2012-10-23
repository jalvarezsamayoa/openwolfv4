# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Usuario do

  before(:each) do
    @usuario = FactoryGirl.build(:usuario)
  end

  # it { should validate_presence_of(:email) }
  # it { should validate_presence_of(:nombre) }
  # it { should validate_presence_of(:cargo) }
  # it { should validate_presence_of(:institucion_id) }

  # it { should validate_uniqueness_of(:email) }
  # it { should validate_uniqueness_of(:nombre) }

  # it { should belong_to(:institucion) }
  # it { should have_and_belong_to_many(:roles) }
  # it { should have_many(:actividades) }
  #  it { should have_many(:documentos) }

  it "debe ser valido" do
    @usuario.should be_valid
  end

  describe '#nombre_cargo' do
    it 'conbina nombre mas cargo del usuario' do
      @usuario.nombre = 'Nombre Usuario'
      @usuario.cargo = 'Cargo'
      @usuario.nombre_cargo.should == 'Nombre Usuario, Cargo'
    end
  end

  describe '#nombre_institucion' do
    it 'conbina nombre mas nombre institucion' do
      @usuario.nombre = 'Nombre Usuario'
      nombre_institucion = @usuario.institucion.nombre
      resultado = 'Nombre Usuario en ' + nombre_institucion
      @usuario.nombre_institucion.should == resultado
    end
  end

  describe 'Cambio de contraseña' do
    it 'debe cambiar al proporcionar pwd y confirmacion' do
      @usuario.password = 'abcdef'
      @usuario.password_confirmation = 'abcdef'
      @usuario.should be_valid
    end

    it "no debe cambiar pwd si no coinciden valores" do
      @usuario.password = 'abcdef'
      @usuario.password_confirmation = 'aaabbb'
      @usuario.should_not be_valid
    end
  end

  #   describe 'Registro de cambios' do
  #     it "debe tener version 1 al ser nuevo" do
  #       @usuario.version.should == 1
  #     end

  #     it "debe de generar registro en el log si hay cambio en los campos" do
  # #      @usuario.nombre = "Nuevo Nombre"
  #       @usuario.nombre = "Nuevo nombre"
  #       @usuario.save!
  #       @usuario.version.should == 2
  #     end
  #   end

  describe 'Notificacion de nueva cuenta de usuario' do
    pending
  end

   describe "#puede_borrar" do
    context "puede borrar un usuario si" do
      it "no tiene relaciones" do
        @usuario.puede_borrar?.should be true
      end
    end

    context "no permite borrar un usuario si" do

      before(:each) do
        @usuario.save
      end

      it "hay actividades relacionadas" do
        FactoryGirl.create :actividad, :usuario => @usuario
        @usuario.reload
        @usuario.puede_borrar?.should be false
      end

      it "hay solicitudes relacionadas " do
        FactoryGirl.create :solicitud, :usuario => @usuario
        @usuario.reload
        @usuario.puede_borrar?.should be false
      end

      it "hay documentos relacionados" do
        FactoryGirl.create :documento, :usuario => @usuario
        @usuario.reload
        @usuario.puede_borrar?.should be false
      end
    end
  end

end
# == Schema Information
#
# Table name: usuarios
#
#  id                   :integer         not null, primary key
#  username             :string(255)
#  email                :string(255)
#  nombre               :string(255)
#  cargo                :string(255)
#  puesto_id            :integer
#  institucion_id       :integer
#  essupervisorarea     :boolean
#  encrypted_password   :string(255)
#  password_salt        :string(255)
#  sign_in_count        :integer
#  failed_attempts      :integer
#  last_request_at      :datetime
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  genero               :boolean         default(FALSE)
#  fecha_nacimiento     :date
#  direccion            :string(255)     default("No Disponible"), not null
#  telefonos            :string(255)     default("No Disponible"), not null
#  openid_identifier    :string(255)
#  confirmation_token   :string(255)
#  confirmed_at         :datetime
#  confirmation_sent_at :datetime
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  unlock_token         :string(255)
#  locked_at            :datetime
#  activo               :boolean         default(TRUE)
#
