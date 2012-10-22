#institution.rb
module Openwolf
  module Core
    module Institucion
      ESTADO_GUATEMALA = 1
      TIPO_RAIZ = 1
      TIPO_PODER = 2
      TIPO_MINISTERIO = 3
      TIPO_INSTITUCION = 4
      TIPOS = {1 => "EstadoGT", 2 => "Poder", 3 => "Ministerio", 4 => "Institucion"}
      TIPOS_OPTIONS = [["EstadoGT", 1],
                       ["Poder", 2],
                       ["Ministerio", 3],
                       ["Institucion", 4]]

      module ClassMethods

      end

      module InstanceMethods
        def tipo_nombre
          return TIPOS[tipoinstitucion_id]
        end

        def to_label
          nombre
        end

        def familia
          self.self_and_ancestors.asignables.concat( self.children.asignables  )
        end

        def familia_activa
          self.self_and_ancestors.activas.asignables.concat( self.children.asignables  )
        end

        ######################################
        # Metodos para estadisticas
        #####################################

        def ano_minimo
          fecha_minima = self.solicitudes.minimum("fecha_creacion")
          i_ano_min = (fecha_minima.nil? ? Date.today.year  : fecha_minima.year)
          return i_ano_min
        end

        def total_solicitudes(ano = Date.today.year)
          self.solicitudes.activas.creadas_en_ano(ano).count
        end

        def solicitudes_por_estado(ano = Date.today.year)
          estados = Estado.select('estados.nombre, count(solicitudes.estado_id) as total_solicitudes').joins(:solicitudes).where("solicitudes.anulada = ? and solicitudes.institucion_id = ? and extract(year from solicitudes.fecha_creacion) = ?",false,self.id,ano).group('estados.nombre')
          return estados
        end

        def solicitudes_por_via_solicitud(ano = Date.today.year)
          estados = Via.select('vias.nombre, count(solicitudes.via_id) as total_solicitudes').joins(:solicitudes).where("solicitudes.anulada = ? and solicitudes.institucion_id = ? and extract(year from solicitudes.fecha_creacion) = ?",false,self.id,ano).group('vias.nombre')
          return estados
        end



        def solicitudes_por_ano
          solicitudes =  Solicitud.find_by_sql("select extract(year from solicitudes.fecha_creacion) as ano,  count(solicitudes.id) as total_solicitudes, avg(solicitudes.tiempo_respuesta) as promedio_dias_respuesta  from solicitudes where institucion_id = #{self.id} and anulada = #{false} and solicitudes.fecha_completada is not null group by extract(year from solicitudes.fecha_creacion) order by extract(year from solicitudes.fecha_creacion) asc")

          return solicitudes
        end

        def solicitudes_por_mes_ano
          solicitudes =  Solicitud.find_by_sql("select extract(year from solicitudes.fecha_creacion) as ano, extract(month from solicitudes.fecha_creacion) as mes,  count(solicitudes.id) as total_solicitudes, avg(solicitudes.tiempo_respuesta) as promedio_dias_respuesta from solicitudes where institucion_id = #{self.id} and anulada = #{false} and solicitudes.fecha_completada is not null group by extract(year from solicitudes.fecha_creacion), extract(month from solicitudes.fecha_creacion) order by extract(year from solicitudes.fecha_creacion) asc, extract(month from solicitudes.fecha_creacion) asc")
          return solicitudes
        end

        def tiempo_respuesta_promedio(ano = Date.today.year)
          tiempo = Solicitud.find_by_sql("select avg(solicitudes.tiempo_respuesta) as promedio from solicitudes where solicitudes.institucion_id = #{self.id} and anulada = #{false} and solicitudes.fecha_completada is not null and extract(year from solicitudes.fecha_creacion) = #{ano}")
          return tiempo[0].promedio.to_f.round()
        end

        def solicitudes_por_genero_ano
          solicitudes = Solicitud.find_by_sql("select genero_id, extract(year from solicitudes.fecha_creacion) as ano,  count(solicitudes.id) as total_solicitudes from solicitudes where institucion_id = #{self.id} and anulada = #{false}  group by genero_id, extract(year from solicitudes.fecha_creacion)  order by genero_id, extract(year from solicitudes.fecha_creacion) desc")
        end


        def encargado_udip
          return nil if self.usuarios.nil?
          return self.usuarios.activos.supervisores.first
        end



        def cleanup

          if self.abreviatura.empty?
            unless self.nombre.empty?
              nombres = self.nombre.split(' ')
              nombres.each {|n| self.abreviatura += n.slice(0..0) }
            end
          end

          # verficamos los codigos de la institucion
          if self.unidad_ejecutora == '0' or self.unidad_ejecutora.empty?
            self.unidad_ejecutora = '000'
          end


        end

      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end

    end
  end
end
