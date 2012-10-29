# documento_traslado.rb
module Openwolf
  module Archivo
    module Traslado
      module ClassMethods

      end

      module InstanceMethods
        #creamos el documento que se traslada
        def crear_documento
          new_doc = clone_documento(self.documento)
          new_doc.move_to_child_of(self.documento)
          self.documento_destinatario_id = new_doc.id
          new_doc
        end

        def nuevo_numero_documento(old_doc)
          n = ::Documento.where('documentos.numero like ?','%'+old_doc.numero+'%').count
          n = n + 1 if n > 1
          old_doc.numero + '-' + n.to_s.rjust(3,'0')
        end

        def clone_documento(old_doc)
          new_doc = old_doc.dup
          new_doc.numero = nuevo_numero_documento(old_doc)
          new_doc.original = self.original
          new_doc.save!
          new_doc
        end


      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
      end
    end
  end
end
