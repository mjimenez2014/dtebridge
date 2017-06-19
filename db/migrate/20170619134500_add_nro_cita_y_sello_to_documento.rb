class AddNroCitaYSelloToDocumento < ActiveRecord::Migration
  def change
    add_column :documentos, :Nrocita, :string
    add_column :documentos, :Sello, :string
  end
end
