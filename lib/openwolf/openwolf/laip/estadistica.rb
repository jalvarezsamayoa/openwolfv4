module Openwolf
  module Laip
    class Estadistica

      attr_reader :institucion

      def initialize(institucion)
        @institucion = institucion
      end

      ######################################
      # Metodos para estadisticas
      #####################################

      def ano_minimo
        fecha_minima = institucion.solicitudes.minimum("fecha_creacion")
        i_ano_min = (fecha_minima.nil? ? Date.today.year  : fecha_minima.year)
        return i_ano_min
      end

      def total_solicitudes(ano = Date.today.year)
        institucion.solicitudes.activas.creadas_en_ano(ano).count
      end

      def solicitudes_por_estado(ano = Date.today.year)
        Estado.select('estados.nombre, count(solicitudes.estado_id) as total_solicitudes')
        .joins(:solicitudes)
        .where("solicitudes.anulada = ? and solicitudes.institucion_id = ? and extract(year from solicitudes.fecha_creacion) = ?",false, @institucion.id, ano)
        .group('estados.nombre')
      end

      def solicitudes_por_via_solicitud(ano = Date.today.year)
        Via.select('vias.nombre, count(solicitudes.via_id) as total_solicitudes')
        .joins(:solicitudes)
        .where("solicitudes.anulada = ? and solicitudes.institucion_id = ? and extract(year from solicitudes.fecha_creacion) = ?",false,institucion.id,ano)
        .group('vias.nombre')
      end



      def solicitudes_por_ano
        ::Solicitud.find_by_sql("select extract(year from solicitudes.fecha_creacion) as ano,  \
          count(solicitudes.id) as total_solicitudes, \
          avg(solicitudes.tiempo_respuesta) as promedio_dias_respuesta  \
          from solicitudes \
          where institucion_id = #{institucion.id} \
          and anulada = #{false} \
          and solicitudes.fecha_completada is not null \
          group by extract(year from solicitudes.fecha_creacion) \
          order by extract(year from solicitudes.fecha_creacion) asc")
      end

      def solicitudes_por_mes_ano
        ::Solicitud.find_by_sql("select extract(year from solicitudes.fecha_creacion) as ano, \
          extract(month from solicitudes.fecha_creacion) as mes,  \
          count(solicitudes.id) as total_solicitudes, \
          avg(solicitudes.tiempo_respuesta) as promedio_dias_respuesta \
          from solicitudes \
          where institucion_id = #{institucion.id} \
          and anulada = #{false} \
          and solicitudes.fecha_completada is not null \
          group by extract(year from solicitudes.fecha_creacion), \
          extract(month from solicitudes.fecha_creacion) \
          order by extract(year from solicitudes.fecha_creacion) asc, \
          extract(month from solicitudes.fecha_creacion) asc")
      end

      def tiempo_respuesta_promedio(ano = Date.today.year)
        tiempo = ::Solicitud.find_by_sql("select avg(solicitudes.tiempo_respuesta) as promedio \
          from solicitudes \
          where solicitudes.institucion_id = #{institucion.id} \
          and anulada = #{false} \
          and solicitudes.fecha_completada is not null \
          and extract(year from solicitudes.fecha_creacion) = #{ano}")
        return tiempo[0].promedio.to_f.round()
      end

      def solicitudes_por_genero_ano
        ::Solicitud.find_by_sql("select genero_id, \
          extract(year from solicitudes.fecha_creacion) as ano,  \
          count(solicitudes.id) as total_solicitudes \
          from solicitudes \
          where institucion_id = #{institucion.id} \
          and anulada = #{false}  \
          group by genero_id, \
          extract(year from solicitudes.fecha_creacion)  \
          order by genero_id, \
          extract(year from solicitudes.fecha_creacion) desc")
      end
    end
  end
end
