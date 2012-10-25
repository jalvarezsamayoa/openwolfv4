# -*- coding: utf-8 -*-
#estadistica_spec.rb
require File.dirname(__FILE__) + '/../spec_helper'

describe Openwolf::Laip::Estadistica do


  def estadistica(institucion = nil)
    institucion ||= FactoryGirl.create :institucion
    Openwolf::Laip::Estadistica.new(institucion)
  end

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

  describe "total_solicitudes" do
    it "debe regresar las solcitudes activas creadas en un ano" do
      solicitud = FactoryGirl.create :solicitud, :fecha_creacion => Date.today
      estadistica(solicitud.institucion).total_solicitudes(Date.today.year).should == 1
    end
  end

  describe "solicitudes_por_estado" do
    it "debe regresar las solicitudes creadas en un ano agrupadas por estado" do
      institucion = FactoryGirl.create(:institucion)

      Estado.all.each do |estado|
        FactoryGirl.create(:solicitud, :institucion => institucion, :estado_id => estado.id)
      end

      estadistica(institucion).solicitudes_por_estado(Date.today.year).size.should have(Estado.count).items
    end
  end

  describe "solicitudes_por_via_solicitud" do
    it "debe regresar la solcitudes creadas en un ano agrupadas por via de solicitud" do
      institucion = FactoryGirl.create(:institucion)

      Via.all.each { |via|
        FactoryGirl.create(:solicitud, :institucion => institucion, :via => via)
      }

      estadistica(institucion).
        solicitudes_por_via_solicitud(Date.today.year).
        size.should have(Via.count).items
    end
  end

  describe "solicitudes_por_ano" do
    it "regresa total de solicitudes completadas con dias promedio de entrega agrupadas por ano" do
      institucion = FactoryGirl.create(:institucion)

      FactoryGirl.create(:solicitud, :institucion => institucion, \
                         :fecha_completada => Date.today, :tiempo_respuesta => 1)

      FactoryGirl.create(:solicitud, :institucion => institucion, \
                         :fecha_creacion => Date.today - 1.year, \
                         :fecha_completada => Date.today - 1.year, \
                         :tiempo_respuesta => 1)

      estadistica(institucion).
        solicitudes_por_ano.
        size.should == 2
    end
  end

  describe "solicitudes_por_mes_ano" do
    it "regresa total de solicitudes y tiempo respuesta agrupadas por mes y ano" do
      institucion = FactoryGirl.create(:institucion)

      FactoryGirl.create(:solicitud, :institucion => institucion, \
                         :fecha_completada => Date.today, :tiempo_respuesta => 1)

      FactoryGirl.create(:solicitud, :institucion => institucion, \
                         :fecha_creacion => Date.today - 1.month, \
                         :fecha_completada => Date.today - 1.month, \
                         :tiempo_respuesta => 1)

      estadistica(institucion).
        solicitudes_por_mes_ano.
        size.should == 2

    end
  end

  describe "tiempo_respuesta_promedio" do
    it "regresa el tiempo promedio de respuesta de solicitudes creadas en ano" do
      institucion = FactoryGirl.create(:institucion)

      FactoryGirl.create(:solicitud, :institucion => institucion, \
                         :fecha_completada => Date.today, :tiempo_respuesta => 1)

      estadistica(institucion).
        tiempo_respuesta_promedio(Date.today.year).should == 1.0
    end
  end

  describe "solicitudes_por_genero_ano" do
    fixtures :generos
    it "regresa total de solicitudes creadas agrupadas por genero y ano" do
      institucion = FactoryGirl.create(:institucion)

      Genero.all.each { |g|
        FactoryGirl.create(:solicitud,
                           :institucion => institucion, \
                           :genero => g)
      }

      estadistica(institucion).
        solicitudes_por_genero_ano.size.should == 2

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
