class AddPropiedadesToMpagocompra < ActiveRecord::Migration
  def change
    add_column :mpagocompras, :GlosaPagos, :string
  end
end
