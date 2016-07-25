class AddTipoLibroToCompmanual < ActiveRecord::Migration
  def change
    add_column :compmanuals, :tipolibro, :string
    add_column :compmanuals, :codautrec, :string
  end
end
