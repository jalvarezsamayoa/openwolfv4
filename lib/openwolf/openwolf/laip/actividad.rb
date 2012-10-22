module Openwolf
  module Laip
    module Actividad
      ESTADO_ACTIVA = 1
      ESTADO_COMPLETADA = 3


      def marcar_como_terminada(fecha = Date.today)
        #marcamos actividad como terminada
        self.estado_id = ESTADO_COMPLETADA
        self.fecha_resolucion = fecha
        if self.save
          #actualizamos el estado de la solicitud
          self.solicitud.actividad_terminada(fecha)
        else
          return false
        end
      end

      private

      def notificar_asignacion
        Notificaciones.delay.nueva_asignacion(self) unless (self.dont_send_email == true)
      end

      def actualizar_solicitud
        self.solicitud.actualizar_asignaciones unless self.solicitud.nil?
      end

      def completar_informacion
        self.institucion_id = self.usuario.institucion_id unless self.usuario.nil?
        self.fecha_asignacion = Date.today if self.fecha_asignacion.nil?
        self.estado_id = ESTADO_ACTIVA if self.estado_id.nil?
      end

      def guardar_version?
        return self.solicitud.guardar_version?
      end
    end
  end
end
