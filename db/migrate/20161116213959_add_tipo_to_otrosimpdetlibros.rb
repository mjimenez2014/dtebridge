class AddTipoToOtrosimpdetlibros < ActiveRecord::Migration
  def change
    add_column :otrosimpdetlibros, :tipodte, :integer
  end
end
