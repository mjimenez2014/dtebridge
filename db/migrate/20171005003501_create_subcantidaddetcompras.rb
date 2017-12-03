class CreateSubcantidaddetcompras < ActiveRecord::Migration
  def change
    create_table :subcantidaddetcompras do |t|
      t.float :SubQty
      t.string :SubCod
      t.integer :TipCodSubQty
      t.references :detcompra, index: true

      t.timestamps
    end
  end
end
