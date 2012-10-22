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

        def estadistica
          @estadistica ||= Openwolf::Laip::Estadistica.new(self)
        end

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
