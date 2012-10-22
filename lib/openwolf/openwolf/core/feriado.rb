module Openwolf
  module Core
    module Feriado

      TIPO_NACIONAL = 1
      TIPO_LOCAL = 2
      TIPOS = [["Nacional", 1], ["Local", 2]]

      module ClassMethods
        # indica si hay feriado en una fecha para una institucion
        def hay_feriado?(opts = {})
          return false if opts.nil?

          opts[:fecha] = Date.today if opts[:fecha].nil?
          opts[:institucion_id] = Institucion::ESTADO_GUATEMALA if opts[:institucion_id].nil?

          #verficamos feriados
          feriado = self.por_institucion(opts[:institucion_id]).en_fecha(opts[:fecha]).limit(1)

          l_hay_feriado  = ((feriado.nil? or feriado.empty?) ? false : true)

          return l_hay_feriado
        end

        # modifica una fecha hasta retornar un dia laborarl
        def obtener_fecha_valida(d_fecha_entrega, institucion_id)
          #logger.debug { "Obteniendo fecha valida" }

          #es la ultima fecha feriado nacional
          #logger.debug { "Verificando feriado nacional" }
          feriado_nacional = self.hay_feriado?({:fecha => d_fecha_entrega})
          if feriado_nacional == true
            #logger.debug { "Hay feriado, recalculando..." }
            d_fecha_entrega += 1.day

            d_fecha_entrega = self.obtener_fecha_valida(d_fecha_entrega, institucion_id)
          end

          #es la ultima fecha feriado local
          #logger.debug { "Verificando feriado local" }
          feriado_local = self.hay_feriado?({:fecha => d_fecha_entrega, :institucion_id => institucion_id})
          if feriado_local == true
            #logger.debug { "Hay feriado recalculando..." }
            d_fecha_entrega += 1.day

            d_fecha_entrega = self.obtener_fecha_valida(d_fecha_entrega, institucion_id)
          end

          # verificamos que la nueve fecha sea dia laboral
          #logger.debug { "Verificando dia sabado" }
          if d_fecha_entrega.wday == 6
            #logger.debug { "Es sabado, recalculando.." }
            d_fecha_entrega += 1.day
            d_fecha_entrega = self.obtener_fecha_valida(d_fecha_entrega, institucion_id)
          end

          #logger.debug { "Verificando dia domingo" }
          if d_fecha_entrega.wday == 0
            #logger.debug { "Es domingo, recalculando..." }
            d_fecha_entrega += 1.day
            d_fecha_entrega = self.obtener_fecha_valida(d_fecha_entrega, institucion_id)
          end

          #logger.debug { "Fecha valida obtenida" }
          return d_fecha_entrega
        end

        #calcula los dias calendario de respuesta
        def calcular_dias_no_laborales(opts = {})
          opts[:fecha] = Date.today if opts[:fecha].nil?
          opts[:dias] = 10 if opts[:dias].nil?

          fecha = opts[:fecha]
          dias = opts[:dias]

          #removermos dias no habiles
          dias_no_laborales = 0
          dias.times do |i|

            dia = (fecha + i)
            # es fin de semana
            if (dia.wday == 0 or dia.wday == 6)
              dias_no_laborales += 1
            else

              # es feriado global
              if self.hay_feriado?(:fecha => dia,
                                   :institucion_id => Institucion::ESTADO_GUATEMALA)
                dias_no_laborales += 1
              end

              # es feriado local
              unless opts[:institucion_id].nil?
                if self.hay_feriado?(:fecha => dia,
                                     :institucion_id => opts[:institucion_id])
                  dias_no_laborales += 1
                end
              end

            end #(6..7)
          end #dias.times

          return dias_no_laborales
        end #self.calcular_dias_no_laborales
      end

      module InstanceMethods
        def tipo_feriado
          return 'Nacional' if tipoferiado_id == TIPO_NACIONAL
          'Local'
        end

        def es_dia_laboral?(hoy = nil)
          hoy = Date.civil(Date.today.year,self.mes,self.dia) if hoy.nil?
          l_finsemana = (hoy.wday == 0 or hoy.wday == 6)
          return !l_finsemana
        end

        def cleanup
          self.fecha = Date.civil(Date.today.year, self.mes, self.dia)

          if self.tipoferiado_id == TIPO_NACIONAL
            self.institucion_id = Institucion::ESTADO_GUATEMALA
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
