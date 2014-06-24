class CreateGuidedetails < ActiveRecord::Migration
  def change
    create_table :guidedetails do |t|
      t.integer :NroLinDet
      t.string :TpoCodigo
      t.string :VlrCodigo
      t.integer :IndExe
      t.string :IndAgente
      t.integer :MntBaseFaena
      t.integer :MntMargComer
      t.integer :PrcConsFinal
      t.string :NmbItem
      t.string :DscItem
      t.integer :QtyRef
      t.string :UnmdRef
      t.integer :PrcRef
      t.integer :QtyItem
      t.integer :SubQty
      t.string :SubCod
      t.string :FchElabor
      t.string :FchVencim
      t.string :UnmdItem
      t.integer :PrcItem
      t.integer :PrcOtrMon
      t.string :Moneda
      t.integer :FctConv
      t.integer :DctoOtrMnda
      t.integer :RecargoOtrMnda
      t.integer :MontoItemOtrMnda
      t.integer :DescuentoPct
      t.integer :DescuentoMonto
      t.string :TipoDscto
      t.integer :ValorDscto
      t.integer :RecargoPct
      t.integer :RecargoMonto
      t.string :TipoRecargo
      t.integer :ValorRecargo
      t.string :CodImpAdic
      t.integer :MontoItem
      t.references :guide, index: true

      t.timestamps
    end
  end
end
