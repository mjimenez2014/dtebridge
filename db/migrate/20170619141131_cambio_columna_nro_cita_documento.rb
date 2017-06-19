class CambioColumnaNroCitaDocumento < ActiveRecord::Migration
	def self.up
		rename_column :documentos, :Nrocita, :NroCita
	end

	def self.down

	end
end
