class CreateImpretotrmndacompras < ActiveRecord::Migration
  def change
    create_table :impretotrmndacompras do |t|
      t.integer :TipoImpOtrMnda
      t.float :TasaImpOtrMnda
      t.float :VlrImpOtrMnda
      t.references :doccompra, index: true

      t.timestamps
    end
  end
end
