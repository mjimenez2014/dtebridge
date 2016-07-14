class AddTipoPagoToDocumentos < ActiveRecord::Migration
  def change
    add_column :documentos, :CondVenta, :string
    add_column :documentos, :MedioPago, :string
  end
end
