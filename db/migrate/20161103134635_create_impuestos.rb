class CreateImpuestos < ActiveRecord::Migration
  def change
    create_table :impuestos do |t|
      t.string :name
      t.integer :tipoimp
      t.float :tasaimp
      t.integer :montoimp
      t.text :descripcion
      t.text :validacion

      t.timestamps
    end
  end
end
