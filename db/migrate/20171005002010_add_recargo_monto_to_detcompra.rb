class AddRecargoMontoToDetcompra < ActiveRecord::Migration
  def change
    add_column :detcompras, :RecargoMonto, :integer
  end
end
