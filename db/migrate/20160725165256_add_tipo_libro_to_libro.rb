class AddTipoLibroToLibro < ActiveRecord::Migration
  def change
    add_column :libros, :tipolibro, :string
    add_column :libros, :codautrec, :string
  end
end
