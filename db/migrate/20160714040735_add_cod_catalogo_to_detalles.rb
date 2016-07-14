class AddCodCatalogoToDetalles < ActiveRecord::Migration
  def change
    add_column :detalles, :CodCatalog, :string
  end
end
