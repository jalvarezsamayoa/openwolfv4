# documento_traslado.rb
module Openwolf
  module Archivo
    module Traslado
      module ClassMethods

      end

      module InstanceMethods
        #creamos el documento que se traslada
        def crear_documento
          old_doc =  self.documento

          n = Documento.where('documentos.numero like ?','%'+old_doc.numero+'%').count

          n = n + 1 if n > 1

          old_doc.numero = old_doc.numero + '-' + n.to_s.rjust(3,'0')
          old_doc.original = self.original


          new_doc =  Documento.new( old_doc.attributes )

          new_doc.save!

          new_doc.move_to_child_of(old_doc)

          self.documento_destinatario_id = new_doc.id
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
