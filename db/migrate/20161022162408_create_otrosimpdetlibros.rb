class CreateOtrosimpdetlibros < ActiveRecord::Migration
  def change
    create_table :otrosimpdetlibros do |t|
      t.string :TipoImp
      t.float :TasaImp
      t.integer :MontoImp
      t.references :detlibro, index: true

      t.timestamps
    end
  end
end
