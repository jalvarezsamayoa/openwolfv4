# documento.rb
module Openwolf
  module Archivo
    module Documento

      ORIGEN_INTERNO = 1
      ORIGEN_EXTERNO = 2
      ORIGENES = [["Interno", ORIGEN_INTERNO], ["Externo", ORIGEN_EXTERNO]]
      ESTADO_BORRADOR = 1
      ESTADO_ENVIADO = 2
      ESTADOS = [["Borrador",ESTADO_BORRADOR], ["Enviado", ESTADO_ENVIADO]]
      ORIGINAL = 1
      COPIA = 0

      module ClassMethods
        def nuevo_numero(institucion, codigo)
          return true
        end

      end

      module InstanceMethods
        def archivado?
          return (!self.archivo_id.nil?)
        end

        def archivo_nombre
          self.archivo.nil? ? 'Documento NO Archivado' : self.archivo.nombre
        end

        def clasificacion_nombre
          self.documentoclasificacion.nombre
        end

        def categoria_nombre
          self.documentocategoria.nombre
        end

        def autor_datos
          self.autor.nombre + ', ' + self.autor.cargo + ', ' + self.autor.institucion.nombre
        end

        def autor_nombre
          self.autor.nombre + ', ' + self.autor.cargo
        end

        def institucion_nombre
          self.institucion.nombre
        end

        def origen_nombre
          return 'Interno' if self.origen_id == ORIGEN_INTERNO
          return 'Externo'
        end

        def estado_nombre
          return 'Borrador' if self.estado_envio_id == ESTADO_BORRADOR
          return 'Enviado' if self.estado_envio_id == ESTADO_ENVIADO
        end


        private

        def completar_informacion
          #asignar categoria
          self.documentocategoria_id = self.documentoclasificacion.documentocategoria_id

          #asignar institucion
          self.institucion_id = self.usuario.institucion_id

          #estado de envio
          self.estado_envio_id = ESTADO_BORRADOR

          #tipo de copia
          self.original = ORIGINAL if self.original.nil?

          #asignamos archivo
          #    a = self.institucion.archivos.first
          #    self.archivo_id = a.id unless a.nil?

          #asignamos numero a documento si este es interno
          if generar_numero?

            self.numero = self.class.nuevo_numero(self.institucion, nil)

            codigo = self.documentoclasificacion.codigo

            i = self.class.count(:conditions => ["documentos.institucion_id = ? and date_part(\'year\',documentos.created_at) = ?", self.institucion_id, Date.today.year ] ).to_i + 1
            self.numero = self.institucion.codigo + '-'+ codigo + '-' +  Date.today.year.to_s + '-' + i.to_s.rjust(6,'0')

          end


        end

        def generar_numero?
          l_generar = false

          if self.original == true
            if (self.origen_id == ORIGEN_INTERNO) || (self.origen_id == ORIGEN_EXTERNO and self.numero.empty?)
              l_generar = true
            end
          end

          return l_generar
        end


      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
