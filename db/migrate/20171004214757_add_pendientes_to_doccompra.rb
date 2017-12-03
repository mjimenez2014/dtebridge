class AddPendientesToDoccompra < ActiveRecord::Migration
  def change
    add_column :doccompras, :TpoTranCompra, :string
    add_column :doccompras, :integer, :string
    add_column :doccompras, :TpoTranVenta, :integer
    add_column :doccompras, :FmaPagExp, :string
    add_column :doccompras, :FchCancel, :string
    add_column :doccompras, :MntCancel, :integer
    add_column :doccompras, :SaldoInsol, :integer
    add_column :doccompras, :PeriodoDesde, :string
    add_column :doccompras, :PeriodoHasta, :string
    add_column :doccompras, :MedioPago, :string
    add_column :doccompras, :TipoCtaPago, :string
    add_column :doccompras, :NumCtaPago, :string
    add_column :doccompras, :BcoPago, :string
    add_column :doccompras, :TermPagoGlosa, :string
    add_column :doccompras, :TermPagoDias, :string
    add_column :doccompras, :MntFlete, :float
    add_column :doccompras, :MntSeguro, :float
    add_column :doccompras, :CodPaisRecep, :integer
    add_column :doccompras, :CodPaisDestin, :integer
    add_column :doccompras, :MontoPeriodo, :integer
    add_column :doccompras, :SaldoAnterior, :integer
    add_column :doccompras, :TpoCambio, :integer
    add_column :doccompras, :MntNetoOtrMnd, :float
    add_column :doccompras, :MntExeOtrMnda, :float
    add_column :doccompras, :MntFaeCarneOtrMnda, :float
    add_column :doccompras, :MntMargComOtrMnda, :integer
    add_column :doccompras, :IVAOtrMnda, :float
    add_column :doccompras, :VANoRetOtrMnda, :float
    add_column :doccompras, :MntTotOtrMnda, :float
  end
end
