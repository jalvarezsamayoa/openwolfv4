# -*- coding: utf-8 -*-
#estadistica_spec.rb
require File.dirname(__FILE__) + '/../spec_helper'

describe Openwolf::Laip::Estadistica do

  let(:estadistica) { Openwolf::Laip::Estadistica.new( FactoryGirl.create(:institucion ) )}

  describe ".new" do
    it "debe cargar una institucion" do
      estadistica.institucion.should be_instance_of(Institucion)
    end
  end

  describe "#ano_minimo" do
    it "debe retornar el año actual si no hay solicitudes" do
      Institucion.any_instance.stub_chain(:solicitudes, :minimum).and_return(nil)
      estadistica.ano_minimo.should == Date.today.year
    end
  end

  # def setup_defaults
  #   @institucion = FactoryGirl.build(:institucion)
  #   @usuario = FactoryGirl.build(:usuario, :institucion => @institucion)

  #   @departamento = FactoryGirl.build(:departamento)
  #   @municipio = FactoryGirl.build(:municipio, :departamento => @departamento)
  #   @via = FactoryGirl.build(:via)
  #   @profesion = FactoryGirl.build(:profesion)
  #   @genero = FactoryGirl.build(:genero)
  #   @rangoedad = FactoryGirl.build(:rangoedad)
  #   @clasificacion = FactoryGirl.build(:clasificacion)
  #   @documentoclasificacion = FactoryGirl.build(:documentoclasificacion)

  #   @opciones_solicitud = {:departamento => @departamento,
  #     :municipio => @municipio,
  #     :via => @via,
  #     :profesion => @profesion,
  #     :genero => @genero,
  #     :rangoedad => @rangoedad,
  #     :clasificacion => @clasificacion,
  #     :documentoclasificacion => @documentoclasificacion,
  #     :anulada => false,
  #     :dont_send_email => true,
  #     :institucion => @institucion,
  #     :usuario => @usuario}
  # end

  # def solicitud_activa(opts = nil)
  #   unless opts.nil?
  #     opciones = @opciones_solicitud.merge(opts)
  #   else
  #     opciones = @opciones_solicitud
  #   end
  #   FactoryGirl.build(:solicitud, opciones)
  # end

  # def solicitud_entregada(opts = nil)
  #   unless opts.nil?
  #     opciones = @opciones_solicitud.merge(opts)
  #   else
  #     opciones = @opciones_solicitud
  #   end
  #   FactoryGirl.build(:solicitud, opciones)
  # end

  # before(:each) do
  #   setup_defaults
  # end

  #  describe '#total_solicitudes' do
  #   it 'debe regresar la cantidad de solicitudes activas' do
  #     2.times { solicitud_activa }
  #     @institucion.total_solicitudes.should == 2
  #   end
  # end

  #  describe '#solicitudes_por_estado' do
  #    fixtures :estados

  #    it 'deber regresar el numero de solicitudes agrupadas por estado' do
  #      estados = Estado.all
  #      estados.each do |estado|
  #       solicitud_activa({:estado => estado, :dont_set_estado => true})
  #      end
  #      @institucion.solicitudes_por_estado.should have(estados.size).records
  #    end
  # end

  # describe '#solicitudes_por_ano' do
  #   fixtures :estados

  #   it 'deber regresar el numero de solicitudes completadas agrupadas por ano' do



  #      estados.each do |estado|
  #       solicitud_entregada(fecha_xxx)
  #      end
  #      @institucion.solicitudes_por_estado.should have(estados.size).records
  #   end

  # end
end
