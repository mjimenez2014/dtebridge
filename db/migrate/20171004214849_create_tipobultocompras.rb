class CreateTipobultocompras < ActiveRecord::Migration
  def change
    create_table :tipobultocompras do |t|
      t.integer :CodTpoBultos
      t.integer :CantBultos
      t.string :Marcas
      t.string :IdContainer
      t.string :Sello
      t.string :EmisorSello
      t.references :doccompra, index: true

      t.timestamps
    end
  end
end
